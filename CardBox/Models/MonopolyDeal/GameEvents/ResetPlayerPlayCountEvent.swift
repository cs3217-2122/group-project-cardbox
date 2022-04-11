//
//  ResetPlayerPlayCountEvent.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

struct ResetPlayerPlayCountEvent: GameEvent {
    let player: MonopolyDealPlayer

    func updateRunner(gameRunner: GameRunnerProtocol) {
        player.resetPlayCount()
    }
}
