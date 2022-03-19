//
//  CardCollection.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

class CardCollection {
    private var cards: [Card] = []

    var count: Int {
        cards.count
    }

    var topCard: Card? {
        if cards.isEmpty {
            return nil
        }
        return cards[0]
    }

    func getSize() -> Int {
        cards.count
    }

    func getFirstCard() -> Card? {
        if cards.isEmpty {
            return nil
        }
        return cards[0]
    }

    func getCardByIndex(_ index: Int) -> Card? {
        if index < 0 || index >= cards.count {
            return nil
        }

        return cards[index]
    }

    func getTopNCards(n: Int) -> [Card] {
        Array(cards[0..<min(cards.count, n)])
    }

    func removeCard(_ card: Card) {
        guard let cardIndex = cards.firstIndex(where: { $0 === card }) else {
            return
        }
        cards.remove(at: cardIndex)
    }

    func addCard(_ card: Card) {
        cards.append(card)
    }

    func addCard(_ card: Card, offsetFromTop index: Int) {
        // Ensures that add card always add back to the deck
        let actualIndex = max(0, min(index, cards.count))

        cards.insert(card, at: actualIndex)
    }

    func containsCard(_ card: Card) -> Bool {
        containsCard(where: { $0 === card })
    }

    func getCards() -> [Card] {
        self.cards
    }

    func getCard(where predicate: (Card) -> Bool) -> Card? {
        for card in cards {
            if predicate(card) {
                return card
            }
        }
        return nil
    }

    func containsCard(where predicate: (Card) -> Bool) -> Bool {
        cards.contains(where: predicate)
    }

    func shuffle() {
        self.cards.shuffle()
    }

    func contains(card: Card) -> Bool {
        self.cards.contains { cardObject in
            cardObject === card
        }
    }
}
