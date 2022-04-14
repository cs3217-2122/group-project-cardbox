//
//  CardCollection.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

class CardCollection: Identifiable {
    private var cards: [Card] = []

    // TODO: initialise with correct value
    var isFaceUp = true

    init(cards: [Card]) {
        self.cards = cards
    }

    convenience init() {
        self.init(cards: [])
    }

    var count: Int {
        cards.count
    }

    var topCard: Card? {
        if cards.isEmpty {
            return nil
        }
        return cards.first
    }

    var bottomCard: Card? {
        if cards.isEmpty {
            return nil
        }
        return cards.last
    }

    var isEmpty: Bool {
        cards.isEmpty
    }

    func updateState(_ cardCollection: CardCollection) {
        self.cards = cardCollection.cards
    }

    func getCardByIndex(_ index: Int) -> Card? {
        guard index >= 0 && index < cards.count else {
            return nil
        }

        return cards[index]
    }

    func getTopNCards(n: Int) -> [Card] {
        guard n > 0 else {
            return []
        }

        return Array(cards[0..<min(cards.count, n)])
    }

    func removeCard(_ card: Card) {
        guard let cardIndex = cards.firstIndex(where: { $0.isEqual(card) }) else {
            return
        }
        cards.remove(at: cardIndex)
    }

    func removeCards(_ cards: [Card]) {
        for card in cards {
            removeCard(card)
        }
    }

    func addCard(_ card: Card) {
        guard !containsCard(card) else {
            return
        }

        cards.append(card)
    }

    func addCard(_ card: Card, offsetFromTop index: Int) {
        guard !containsCard(card) else {
            return
        }

        // Ensures that add card always add back to the deck
        let actualIndex = max(0, min(index, cards.count))

        cards.insert(card, at: actualIndex)
    }

    func addCards(_ cards: [Card], offsetFromTop index: Int) {
        for card in cards {
            addCard(card, offsetFromTop: index)
        }
    }

    func containsCard(_ card: Card) -> Bool {
        containsCard(where: { $0 === card })
    }

    func containsCard(where predicate: (Card) -> Bool) -> Bool {
        cards.contains(where: predicate)
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

    func shuffle() {
        self.cards.shuffle()
    }
}
