//
//  AddPlayerEvent.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct AddPlayerEvent: GameEvent {
    let player: Player

    func updateRunner(gameRunner: GameRunner) {
        gameRunner.players.addPlayer(player)
    }
}
