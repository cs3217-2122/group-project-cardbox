//
//  SetPlayerAdditionalParamsEvent.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

struct SetPlayerAdditionalParamsEvent: GameEvent {
    let player: Player
    let key: String
    let value: String

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.setAdditionalParams(key: key, value: value)
    }
}
