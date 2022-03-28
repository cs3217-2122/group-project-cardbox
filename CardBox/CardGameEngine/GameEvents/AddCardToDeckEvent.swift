//
//  AddCardToDeck.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct AddCardToDeckEvent: GameEvent {
    let card: Card
    let deck: CardCollection

    func updateRunner(gameRunner: GameRunnerProtocol) {
        deck.addCard(card)
    }
}
