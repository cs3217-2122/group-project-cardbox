//
//  DismissMessageEvent.swift
//  CardBox
//
//  Created by user213938 on 4/17/22.
//

struct DismissMessageEvent: GameEvent {
    let message: Message

    func updateRunner(gameRunner: GameRunnerProtocol) {
        gameRunner.dismissMessage(message)
    }
}
