//
//  ShuffleDeckAction.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

struct ShuffleDeckAction: Action {
    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        gameRunner.executeGameEvents([
            ShuffleDeckEvent()
        ])
    }
}
