//
//  EndTurnAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct EndTurnAction: Action {
    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        gameRunner.executeGameEvents([
            EndTurnEvent(),
            AdvanceNextPlayerEvent(),
            SetGameStateEvent(gameState: .start),
            StartTurnEvent()
        ])
    }
}
