//
//  DeckPositionRequestEvent.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

struct DeckPositionRequestEvent: GameEvent {
    let card: Card

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        gameRunner.setCardToReposition(card)
        gameRunner.showDeckPositionRequest()
    }
}
