//
//  SetupEvent.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

struct SetupEvent: GameEvent {
    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        gameRunner.setup()
    }
}
