//
//  EndTurnAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct EndTurnAction: Action {
    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
<<<<<<< HEAD
        gameRunner.executeGameEvents([
            EndTurnEvent()
        ])

        if let currentPlayer = gameRunner.players.currentPlayer {
            gameRunner.executeGameEvents([
                ResetPlayerCardsPlayedEvent(player: currentPlayer)
            ])
        }

        var nextPlayer = gameRunner.players.nextPlayer

        for _ in 0..<gameRunner.players.count {
            guard let nextPlayerUnwrapped = nextPlayer else {
                return
            }

            gameRunner.executeGameEvents([
                SetCurrentPlayerEvent(player: nextPlayerUnwrapped)
            ])

            if !nextPlayerUnwrapped.isOutOfGame {
                break
            }

            nextPlayer = gameRunner.players.nextPlayer
        }

        gameRunner.executeGameEvents([
=======
        gameRunner.executeGameEvents([
            EndTurnEvent(),
            AdvanceNextPlayerEvent(),
>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753
            SetGameStateEvent(gameState: .start),
            StartTurnEvent()
        ])
    }
}
