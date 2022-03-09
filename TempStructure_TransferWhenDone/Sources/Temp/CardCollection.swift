class CardCollection {
    private var cards: [Card] = []

    init() {

    }

    func getFirstCard() -> Card? {
        if cards.isEmpty {
            return nil
        }
        return cards[0]
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

    func addCard(_ card: Card, at index: Int) {
        cards.insert(card, at: index)
    }

    func getCards() -> [Card] {
        return self.cards
    }
}
