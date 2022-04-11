//
//  ResolveRequestEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 12/4/22.
//

import Foundation

struct ResolveRequestEvent: GameEvent {
    let requestID: UUID

    func updateRunner(gameRunner: GameRunnerProtocol) {
        guard let response = gameRunner.globalResponses.first(where: { $0.id == requestID }) else {
            return
        }

    }
}
