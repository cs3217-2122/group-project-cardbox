//
//  MoveCardEvent.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

struct MoveCardsDeckToDeckEvent: GameEvent {
    let cards: [Card]
    let fromDeck: CardCollection
    let toDeck: CardCollection
    let offsetFromTop: Int

    init(cards: [Card], fromDeck: CardCollection, toDeck: CardCollection, offsetFromTop: Int = 0) {
        self.cards = cards
        self.fromDeck = fromDeck
        self.toDeck = toDeck
        self.offsetFromTop = offsetFromTop
    }

    func updateRunner(gameRunner: GameRunnerProtocol) {

        print("cards")
        for card in cards {
            print(type(of: card))
        }
        print("fromDeck")
        for card in fromDeck.getCards() {
            print(type(of: card))
        }
        print("toDeck")
        for card in toDeck.getCards() {
            print(type(of: card))
        }

        guard cards.map({ card in fromDeck.containsCard(card) }).allSatisfy({ $0 && true }) else {
            return
        }

        fromDeck.removeCards(cards)
        toDeck.addCards(cards, offsetFromTop: offsetFromTop)
    }
}
