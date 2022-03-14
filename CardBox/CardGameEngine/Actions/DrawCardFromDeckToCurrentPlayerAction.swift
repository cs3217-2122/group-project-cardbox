enum PlayerTarget {
    case currentPlayer
}

struct DrawCardFromDeckToCurrentPlayerAction: Action {
    let target: PlayerTarget

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        guard let firstCard = gameRunner.deck.getFirstCard() else {
            return
        }

        let player: Player? = {
            switch target {
            case .currentPlayer:
                return gameRunner.players.currentPlayer
            }
        }()

        guard let playerUnwrapped = player else {
            return
        }

        gameRunner.executeGameEvents([
            MoveCardDeckToPlayerEvent(card: firstCard, player: playerUnwrapped)
        ])

        firstCard.onDraw(gameRunner: gameRunner, player: playerUnwrapped)
    }
}
