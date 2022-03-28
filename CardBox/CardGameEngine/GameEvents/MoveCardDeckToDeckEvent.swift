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

    init(card: Card, fromDeck: CardCollection, toDeck: CardCollection, offsetFromTop: Int = 0) {
        self.card = card
        self.fromDeck = fromDeck
        self.toDeck = toDeck
        self.offsetFromTop = offsetFromTop
    }

    func updateRunner(gameRunner: GameRunnerProtocol) {
        fromDeck.removeCard(card)
        toDeck.addCard(card, offsetFromTop: offsetFromTop)
    }
}
