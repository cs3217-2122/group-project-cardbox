//
//  ConditionalAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct ConditionalAction: Action {
    let condition: (GameRunnerReadOnly) -> Bool
    let isTrue: Action
    let isFalse: Action?

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        let isConditionTrue = condition(gameRunner)

        if isConditionTrue {
            isTrue.executeGameEvents(gameRunner: gameRunner)
        } else {
            isFalse?.executeGameEvents(gameRunner: gameRunner)
        }
    }
}
