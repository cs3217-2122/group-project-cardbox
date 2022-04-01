//
//  CustomizedGameEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 1/4/22.
//

struct CustomizedGameEvent: GameEvent {
    let customizedGameEvent: GameEvent

    func updateRunner(gameRunner: GameRunnerProtocol) {
        customizedGameEvent.updateRunner(gameRunner: gameRunner)
    }
}
