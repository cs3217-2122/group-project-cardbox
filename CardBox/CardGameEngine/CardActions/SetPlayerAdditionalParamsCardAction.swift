//
//  SetPlayerAdditionalParamsCardAction.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

struct SetPlayerAdditionalParamsCardAction: CardAction {
    let playerResolver: (GameRunnerReadOnly) -> Player?
    let key: String
    let value: String

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        guard let player = playerResolver(gameRunner) else {
            return
        }

        gameRunner.executeGameEvents([
            SetPlayerAdditionalParamsEvent(player: player, key: key, value: value)
        ])
    }
}
