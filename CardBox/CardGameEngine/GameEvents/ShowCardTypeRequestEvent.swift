//
//  ShowCardTypeRequestEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 1/4/22.
//

struct ShowCardTypeRequestEvent: GameEvent {
    let callback: (String) -> Void
    let cardTypes: [String]

    func updateRunner(gameRunner: GameRunnerProtocol) {
        gameRunner.cardTypeRequest.showRequest(callback: callback, cardTypes: cardTypes)
    }
}
