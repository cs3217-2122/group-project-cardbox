//
//  SendResponseEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import Foundation

struct SendResponseEvent: GameEvent {
    let requestId: UUID
    let value: Any

    func updateRunner(gameRunner: GameRunnerProtocol) {
        guard let request = gameRunner.globalRequests.first(where: { $0.id == requestId }) else {
            return
        }

        if request is IntRequest, let intValue = value as? Int {
            gameRunner.globalResponses.append(IntResponse(requestId: requestId, value: intValue))
        } else if request is OptionsRequest, let optionsValue = value as? String {
            gameRunner.globalResponses.append(OptionsResponse(requestId: requestId, value: optionsValue))
        } else if request is InputTextRequest, let inputTextValue = value as? String {
            gameRunner.globalResponses.append(InputTextResponse(requestId: requestId, value: inputTextValue))
        } else {
            assert(false, "Cannot find or identify type of request")
        }
    }
}
