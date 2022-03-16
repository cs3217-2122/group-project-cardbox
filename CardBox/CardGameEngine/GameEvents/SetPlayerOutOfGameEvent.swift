//
//  SetPlayerOutOfGameEvent.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct SetPlayerOutOfGameEvent: GameEvent {
    let player: Player

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.setOutOfGame(true)
    }
}
