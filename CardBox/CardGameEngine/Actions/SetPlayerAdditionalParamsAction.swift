//
//  SetPlayerAdditionalParamsAction.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

struct SetPlayerAdditionalParamsAction: Action {
    let playerResolver: (GameRunnerReadOnly) -> Player?
    let key: String
    let value: String

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        guard let player = playerResolver(gameRunner) else {
            return
        }

        gameRunner.executeGameEvents([
            SetPlayerAdditionalParamsEvent(player: player, key: key, value: value)
        ])
    }
}
