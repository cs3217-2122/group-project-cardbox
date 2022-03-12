//
//  DisplayMessageEvent.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct DisplayMessageEvent: GameEvent {
    let message: String

    func updateRunner(gameRunner: GameRunner) {
        print(message)
    }
}
