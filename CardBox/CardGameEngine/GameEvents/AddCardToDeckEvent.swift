//
//  AddCardToDeck.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct AddCardToDeckEvent: GameEvent {
    let card: Card

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        gameRunner.deck.addCard(card)
    }
}
