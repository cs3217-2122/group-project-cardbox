//
//  AdvanceNextPlayerEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/3/22.
//

struct AdvanceNextPlayerEvent: GameEvent {
    func updateRunner(gameRunner: GameRunnerProtocol) {
        gameRunner.advanceToNextPlayer()
    }
}
