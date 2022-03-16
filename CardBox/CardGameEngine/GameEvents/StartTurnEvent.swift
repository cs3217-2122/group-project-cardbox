//
//  StartTurnEvent.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

struct StartTurnEvent: GameEvent {
    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        gameRunner.onStartTurn()
    }
}
