//
//  DisplayMessageAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct DisplayMessageAction: Action {
    let message: String

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        gameRunner.executeGameEvents([
            DisplayMessageEvent(message: self.message)
        ])
    }
}
