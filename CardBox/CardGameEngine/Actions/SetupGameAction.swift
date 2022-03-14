//
//  SetupGameAction.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

struct SetupGameAction: Action {
    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        gameRunner.executeGameEvents([
            SetupEvent(),
            SetGameStateEvent(gameState: .waitPlayCard),
            StartTurnEvent()
        ])
    }
}
