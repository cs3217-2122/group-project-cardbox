//
//  ShowCardPositionRequestEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 1/4/22.
//

struct ShowCardPositionRequestEvent: GameEvent {
    let callback: ((Int) -> Void)
    let minValue: Int
    let maxValue: Int

    func updateRunner(gameRunner: GameRunnerProtocol) {
        gameRunner.deckPositionRequest.showRequest(
            callback: callback,
            minValue: minValue,
            maxValue: maxValue
        )
    }
}
