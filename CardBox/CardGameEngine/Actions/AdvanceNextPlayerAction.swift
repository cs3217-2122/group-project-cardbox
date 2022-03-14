//
//  AdvanceNextPlayerAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct AdvanceNextPlayerAction: Action {
    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        guard let nextPlayer = gameRunner.players.nextPlayer else {
            return
        }

        gameRunner.executeGameEvents([
            SetCurrentPlayerEvent(player: nextPlayer)
        ])
    }
}
