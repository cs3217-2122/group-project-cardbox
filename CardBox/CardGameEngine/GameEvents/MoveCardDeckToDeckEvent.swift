//
//  MoveCardEvent.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

struct MoveCardDeckToDeckEvent: GameEvent {
    let card: Card
    let fromDeck: CardCollection
    let toDeck: CardCollection
    let offsetFromTop: Int

    func updateRunner(gameRunner: GameRunnerProtocol) {
        fromDeck.removeCard(card)
        toDeck.addCard(card, offsetFromTop: offsetFromTop)
    }
}
