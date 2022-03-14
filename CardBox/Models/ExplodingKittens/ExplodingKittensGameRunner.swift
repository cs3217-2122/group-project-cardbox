//
//  ExplodingKittensGameRunner.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

class ExplodingKittensGameRunner {

    static func generateGameRunner() -> GameRunner {
        let gameRunner = GameRunner()
        initGameRunner(gameRunner)

        ActionDispatcher.runAction(SetupGameAction(), on: gameRunner)

        return gameRunner
    }

    private static func initGameRunner(_ gameRunner: GameRunner) {
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

    private static func generateBombCard() -> Card {
        let card = Card(name: "Bomb")
        card.addDrawAction(PlayerOutOfGameAction())
        return card
    }

    private static func generateSeeTheFutureCard() -> Card {
        let card = Card(name: "See The Future")
        card.addPlayAction(DisplayTopNCardsFromDeckCardAction(n: 3))
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

        return cards
    }
}
