//
//  ExplodingKittensGameRunnerInitialiser.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

class ExplodingKittensGameRunnerInitialiser: GameRunnerInitialiser {
    static let cardTypeKey = "CARD_TYPE"

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

        let isPlayerTurnCondition: PlayerPlayCondition = { gameRunner, _, player in
            gameRunner.players.currentPlayer === player
        }
        conditions.append(isPlayerTurnCondition)

        let playerAlreadyPlayCondition: PlayerPlayCondition = { _, _, _ in
            true
        }
        conditions.append(playerAlreadyPlayCondition)

        return conditions
    }

    private static func generateBombCard() -> Card {
        let card = Card(name: "Bomb")
        let isTrueCardActions: [CardAction] = [
            PlayerDiscardCardsAction(where: {
                $0.getAdditionalParams(key: cardTypeKey) == ExplodingKittensCardType.defuse.rawValue
            }),
            PlayerInsertCardIntoDeckCardAction(card: card, offsetFromTop: 0)
            // Need to find a way to obtain user input to choose where the user wants to input the card into the deck
        ]
        let isFalseCardActions = [PlayerOutOfGameCardAction()]

        card.addDrawAction(ConditionalCardAction(condition: { _, player, _ in
            player.hasCard(
                where: { $0.getAdditionalParams(key: cardTypeKey) == ExplodingKittensCardType.defuse.rawValue }
            )
        }, isTrueCardActions: isTrueCardActions, isFalseCardActions: isFalseCardActions))

        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.bomb.rawValue)
        return card
    }

    private static func generateSeeTheFutureCard() -> Card {
        let card = Card(name: "See The Future")
        card.addPlayAction(DisplayTopNCardsFromDeckCardAction(n: 3))
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.seeTheFuture.rawValue)
        return card
    }

    private static func generateShuffleCard() -> Card {
        let card = Card(name: "Shuffle")
        card.addPlayAction(ShuffleDeckCardAction())
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.shuffle.rawValue)
        return card
    }

    private static func generateSkipCard() -> Card {
        let card = Card(name: "Skip")
        card.addPlayAction(EndTurnWithoutActionsCardAction())
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.skip.rawValue)
        return card
    }

    private static func generateDefuseCard() -> Card {
        let card = Card(name: "Defuse")
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.defuse.rawValue)
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

        for _ in 0..<4 {
            cards.append(generateShuffleCard())
        }

        for _ in 0..<6 {
            cards.append(generateSkipCard())
        }

        for _ in 0..<5 {
            cards.append(generateSeeTheFutureCard())
        }

        for _ in 0..<4 {
            cards.append(generateRandom1Card())
            cards.append(generateRandom2Card())
            cards.append(generateRandom3Card())
        }

        return cards
    }
}
