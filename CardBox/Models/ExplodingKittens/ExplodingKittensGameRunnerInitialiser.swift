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
        gameRunner.addSetupAction(InitPlayerAction(numPlayers: numPlayers, canPlayConditions: playConditions))

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
    }

    private static func initCardPlayConditions() -> [PlayerPlayCondition] {
        var conditions: [PlayerPlayCondition] = []

<<<<<<< HEAD
        let isPlayerTurnCondition: PlayerPlayCondition = { gameRunner, _, player in
            gameRunner.players.currentPlayer === player
        }
        conditions.append(isPlayerTurnCondition)

        let playerAlreadyPlayCondition: PlayerPlayCondition = { _, _, _ in
            true
        }
        conditions.append(playerAlreadyPlayCondition)
=======
        let isPlayerTurnCondition: PlayerPlayCondition = IsCurrentPlayerPlayCondition()
        conditions.append(isPlayerTurnCondition)

        let ekCondition = ExplodingKittensPlayerPlayCondition()
        conditions.append(ekCondition)
>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753

        return conditions
    }

<<<<<<< HEAD
=======
    private static func generateAttackCard() -> Card {
        let card = Card(name: "Attack")
        card.addPlayAction(SkipTurnCardAction())
        // Need add action to make the next player repeat his turn
        ExplodingKittensUtils.setCardType(card: card, type: ExplodingKittensCardType.attack)
        return card
    }

>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753
    private static func generateBombCard() -> Card {
        let card = Card(name: "Bomb")
        let isTrueCardActions: [CardAction] = [
            PlayerDiscardCardsAction(where: { card in
                guard let cardType = ExplodingKittensUtils.getCardType(card: card) else {
                    return false
                }

                return cardType == ExplodingKittensCardType.defuse
            }),
<<<<<<< HEAD
            PlayerInsertCardIntoDeckCardAction(card: card, offsetFromTop: 0)
=======
            DeckPositionRequestCardAction()
>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753
            // Need to find a way to obtain user input to choose where the user wants to input the card into the deck
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
        card.addPlayAction(PlayerTakesNthCardFromPlayerCardAction(n: 0))
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

    private static func generateRandom1Card() -> Card {
        let card = Card(name: "Random 1")
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.random1.rawValue)
        return card
    }

    private static func generateRandom2Card() -> Card {
        let card = Card(name: "Random 2")
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.random2.rawValue)
        return card
    }

    private static func generateRandom3Card() -> Card {
        let card = Card(name: "Random 3")
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.random3.rawValue)
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
}
