//
//  StepAdditionalParamsAction.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

struct StepAdditionalParamsAction: Action {
    let resolveProperty: (GameRunnerReadOnly) -> Player?
    let key: String
    let step: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        guard let player = resolveProperty(gameRunner) else {
            return
        }

        gameRunner.executeGameEvents([
            StepAdditionalParamsEvent(extendedProperty: player, key: key, step: step)
        ])
    }
}
