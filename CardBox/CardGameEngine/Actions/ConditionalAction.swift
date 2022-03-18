//
//  ConditionalAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct ConditionalAction: Action {
    let condition: (GameRunnerReadOnly) -> Bool
    let isTrueActions: [Action]
    let isFalseActions: [Action]?

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        let isConditionTrue = condition(gameRunner)

        if isConditionTrue {
            for isTrueAction in isTrueActions {
                isTrueAction.executeGameEvents(gameRunner: gameRunner)
            }
        } else {
            guard let isFalseActions = isFalseActions else {
                return
            }

            for isFalseAction in isFalseActions {
                isFalseAction.executeGameEvents(gameRunner: gameRunner)
            }
        }
    }
}
