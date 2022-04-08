//
//  IncrementPlayerPlayCountEvent.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

struct IncrementPlayerPlayCountEvent: GameEvent {
    let player: MonopolyDealPlayer

    func updateRunner(gameRunner: GameRunnerProtocol) {
        player.incrementPlayCount()
    }
}
