//
//  EndTurnAction.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

struct EndTurnAction: Action {
    func run(gameRunner: GameRunnerProtocol) {
        gameRunner.executeGameEvents([
            EndTurnEvent(),
            AdvanceNextPlayerEvent(),
            StartTurnEvent()
        ])
    }
}
