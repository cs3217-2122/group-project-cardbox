//
//  ExplodingKittensGameRunnerInitialiser.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

class ExplodingKittensGameRunnerInitialiser: GameRunnerInitialiser {

    static func getAndSetupGameRunnerInstance() -> GameRunner {
        let gameRunner = GameRunner()

        initialiseGameRunner(gameRunner)
        ActionDispatcher.runAction(SetupGameAction(), on: gameRunner)

        return gameRunner
    }

    static func initialiseGameRunner(_ gameRunner: GameRunnerInitOnly) {
        let numPlayers = 4

        let playConditions = initCardPlayConditions()
        let cardCombos = initCardCombos()
        gameRunner.addSetupAction(InitPlayerAction(numPlayers: numPlayers,
                                                   canPlayConditions: playConditions,
                                                   cardCombos: cardCombos))

        // Distribute defuse cards
        let defuseCards: [Card] = (0..<numPlayers).map { _ in generateDefuseCard() }
        gameRunner.addSetupAction(InitDeckWithCardsAction(cards: defuseCards))
        gameRunner.addSetupAction(DistributeCardsToPlayerAction(numCards: numPlayers))

        let cards = initCards()
        gameRunner.addSetupAction(InitDeckWithCardsAction(cards: cards))
        gameRunner.addSetupAction(ShuffleDeckAction())
        gameRunner.addSetupAction(DistributeCardsToPlayerAction(numCards: 4))

        let bombCards: [Card] = (0..<numPlayers - 1).map { _ in generateBombCard() }
        bombCards.forEach { bombCard in
            gameRunner.addSetupAction(AddCardToDeckAction(card: bombCard))
        }

        gameRunner.addSetupAction(ShuffleDeckAction())

        gameRunner.addEndTurnAction(DrawCardFromDeckToCurrentPlayerAction(target: .currentPlayer))

        gameRunner.setNextPlayerGenerator(ExplodingKittensNextPlayerGenerator())
    }

    private static func initCardPlayConditions() -> [PlayerPlayCondition] {
        var conditions: [PlayerPlayCondition] = []

        let isPlayerTurnCondition: PlayerPlayCondition = IsCurrentPlayerPlayCondition()
        conditions.append(isPlayerTurnCondition)

        let ekCondition = ExplodingKittensPlayerPlayCondition()
        conditions.append(ekCondition)

        return conditions
    }

    private static func generateAttackCard() -> Card {
        let card = Card(name: "Attack")
        card.addPlayAction(SkipTurnCardAction())
        // Need add action to make the next player repeat his turn
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.attack)
        return card
    }

    private static func generateBombCard() -> Card {
        let card = Card(name: "Bomb")
        let isTrueCardActions: [CardAction] = [
            PlayerDiscardCardsAction(where: { card in
                guard let cardType = ExplodingKittensUtils.getCardType(card: card) else {
                    return false
                }

                return cardType == ExplodingKittensCardType.defuse
            }),
            DeckPositionRequestCardAction()
        ]
        let isFalseCardActions = [PlayerOutOfGameCardAction()]

        card.addDrawAction(ConditionalCardAction(condition: { _, player, _ in
            player.hasCard(where: { card in
                guard let cardType = ExplodingKittensUtils.getCardType(card: card) else {
                    return false
                }
                return cardType == ExplodingKittensCardType.defuse
            })
        }, isTrueCardActions: isTrueCardActions, isFalseCardActions: isFalseCardActions))

        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.bomb)
        return card
    }

    private static func generateDefuseCard() -> Card {
        let card = Card(name: "Defuse")
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.defuse)
        return card
    }

    private static func generateFavorCard() -> Card {
        let card = Card(name: "Favor")
        // Similar to generate bomb card, needs user input to choose n
        card.addPlayAction(PlayerTakesNthCardFromPlayerCardAction(n: 0, stateOfN: .given))
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.favor)
        return card
    }

    private static func generateSeeTheFutureCard() -> Card {
        let card = Card(name: "See The Future")
        card.addPlayAction(DisplayTopNCardsFromDeckCardAction(n: 3))
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.seeTheFuture)
        return card
    }

    private static func generateShuffleCard() -> Card {
        let card = Card(name: "Shuffle")
        card.addPlayAction(ShuffleDeckCardAction())
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.shuffle)
        return card
    }

    private static func generateSkipCard() -> Card {
        let card = Card(name: "Skip")

        card.addPlayAction(SkipTurnCardAction())
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.skip)
        return card
    }

    private static func generateRandom1Card() -> Card {
        let card = Card(name: "Random 1")
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.random1)
        return card
    }

    private static func generateRandom2Card() -> Card {
        let card = Card(name: "Random 2")
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.random2)
        return card
    }

    private static func generateRandom3Card() -> Card {
        let card = Card(name: "Random 3")
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.random3)
        return card
    }

    private static func initCards() -> [Card] {
        var cards: [Card] = []

        // TODO:
        // 1. Add 4 Attack cards
        // 2. Add 4 Favor cards
        // 3. Add 5 Nope cards

        for _ in 0 ..< ExplodingKittensCardType.shuffle.initialFrequency {
            cards.append(generateShuffleCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.skip.initialFrequency {
            cards.append(generateSkipCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.seeTheFuture.initialFrequency {
            cards.append(generateSeeTheFutureCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.random1.initialFrequency {
            cards.append(generateRandom1Card())
            cards.append(generateRandom2Card())
            cards.append(generateRandom3Card())
        }

        return cards
    }

    private static func initCardCombos() -> [CardCombo] {
        [generatePairCombo(), generateThreeOfAKindCombo(), generateFiveDifferentCardsCombo()]
    }

    private static func generatePairCombo() -> CardCombo {

        let pair: CardCombo = { cards in
            guard cards.count == 2 else {
                return []
            }

            if allSameExplodingKittensCardType(cards) {
                return []
            }

            return [PlayerTakesNthCardFromPlayerCardAction(n: -1, stateOfN: .random)]
        }

        return pair
    }

    private static func generateThreeOfAKindCombo() -> CardCombo {

        let threeOfAKind: CardCombo = { cards in
            guard cards.count == 3 else {
                return []
            }

            guard allSameExplodingKittensCardType(cards) else {
                    return []
            }

            // TODO: Get user input to choose card, for now its a placeholder card (most likely defuse)
            return [PlayerTakenChosenCardFromPlayerCardAction(cardPredicate: {
                $0.getAdditionalParams(key: ExplodingKittensUtils.cardTypeKey) ==
                    ExplodingKittensCardType.defuse.rawValue
            })]
        }

        return threeOfAKind
    }

    private static func generateFiveDifferentCardsCombo() -> CardCombo {

        let fiveDifferentCards: CardCombo = { cards in
            guard cards.count == 5 else {
                return []
            }

            guard allDifferentExplodingKittensCardType(cards) else {
                return []
            }

            // TODO: Prompt player to choose a card
            return [PlayerTakesChosenCardFromGameplayCardAction()]
        }

        return fiveDifferentCards
    }

    private static func allSameExplodingKittensCardType(_ cards: [Card]) -> Bool {
        if let cardType: String = cards[0].getAdditionalParams(key: ExplodingKittensUtils.cardTypeKey) {
            return cards.allSatisfy({
                $0.getAdditionalParams(key: ExplodingKittensUtils.cardTypeKey) == cardType
            })
        }

        return true
    }

    private static func allDifferentExplodingKittensCardType(_ cards: [Card]) -> Bool {
        let cardTypes: [String] = cards.map({
            guard let cardType = $0.getAdditionalParams(key: ExplodingKittensUtils.cardTypeKey) else {
                // TODO: Exception or assert(false)
                return ""
            }
            return cardType
        })
        let distinctCardTypes = Set<String>(cardTypes)

        return distinctCardTypes.count == cardTypes.count
    }
}
