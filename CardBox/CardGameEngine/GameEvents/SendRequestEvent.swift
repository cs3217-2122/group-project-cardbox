//
//  SendRequestEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

struct SendRequestEvent: GameEvent {
    let request: Request

    func updateRunner(gameRunner: GameRunnerProtocol) {
        // Adds to the global collection of requests
        gameRunner.globalRequests.append(request)

        // Only the caller of the request will add the request to it's local pending request collection
        gameRunner.localPendingRequests.append(request)
    }
}
