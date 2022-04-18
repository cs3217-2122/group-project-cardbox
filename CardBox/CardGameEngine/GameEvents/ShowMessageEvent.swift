//
//  ShowMessageEvent.swift
//  CardBox
//
//  Created by user213938 on 4/17/22.
//

struct ShowMessageEvent: GameEvent {
    let message: Message

    func updateRunner(gameRunner: GameRunnerProtocol) {
        gameRunner.addMessage(message)
    }
}
