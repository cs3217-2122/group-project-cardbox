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
        let cards = initCards()
        gameRunner.addSetupAction(InitDeckWithCardsAction(cards: cards))

        let playConditions = initCardPlayConditions()
        gameRunner.addSetupAction(InitPlayerAction(numPlayers: 4, canPlayConditions: playConditions))

        gameRunner.addSetupAction(ShuffleDeckAction())
        gameRunner.addSetupAction(DistributeCardsToPlayerAction(numCards: 2))

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

    private static func generateAttackCard() -> Card {
        let card = Card(name: "Attack")
        card.addPlayAction(SkipTurnCardAction())
        // Need add action to make the next player repeat his turn
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.attack.rawValue)
        return card
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

    private static func generateDefuseCard() -> Card {
        let card = Card(name: "Defuse")
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.defuse.rawValue)
        return card
    }

    private static func generateFavorCard() -> Card {
        let card = Card(name: "Favor")
        // Similar to generate bomb card, needs user input to choose n
        card.addPlayAction(PlayerTakesNthCardFromPlayerCardAction(n: 0))
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.favor.rawValue)
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
        card.addPlayAction(SkipTurnCardAction())
        card.setAdditionalParams(key: cardTypeKey, value: ExplodingKittensCardType.skip.rawValue)
        return card
    }

    private static func initCards() -> [Card] {
        var cards: [Card] = []

        for _ in 0...5 {
            cards.append(generateBombCard())
        }

        for _ in 0...10 {
            cards.append(generateSeeTheFutureCard())
        }

        for _ in 0...5 {
            cards.append(generateSkipCard())
        }

        for _ in 0...5 {
            cards.append(generateShuffleCard())
        }

        for _ in 0...4 {
            cards.append(generateSkipCard())
        }

        return cards
    }
}
