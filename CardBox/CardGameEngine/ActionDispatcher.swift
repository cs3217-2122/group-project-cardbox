//
//  ActionDispatcher.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

class ActionDispatcher {
    static func runAction(_ action: Action, on gameRunner: GameRunnerReadOnly) {
        action.executeGameEvents(gameRunner: gameRunner)
    }
}
