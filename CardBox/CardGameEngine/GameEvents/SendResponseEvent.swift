//
//  SendResponseEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

struct SendResponseEvent: GameEvent {
    let response: IntResponse

    func updateRunner(gameRunner: GameRunnerProtocol) {
        gameRunner.globalResponses.append(response)
    }
}
