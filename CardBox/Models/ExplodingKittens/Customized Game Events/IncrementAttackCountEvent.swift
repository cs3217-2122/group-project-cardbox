//
//  IncrementAttackCountEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 1/4/22.
//

struct IncrementAttackCountEvent: GameEvent {
    let player: ExplodingKittensPlayer

    func updateRunner(gameRunner: GameRunnerProtocol) {
        player.incrementAttackCount()
    }
}
