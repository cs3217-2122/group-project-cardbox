class CardCollection<T: Card> {
    private var cards: [T] = []

    init() {

    }

    func getFirstCard() -> T? {
        if cards.isEmpty {
            return nil
        }
        return cards[0]
    }

    func removeCard(_ card: T) {
        guard let cardIndex = cards.firstIndex(where: { $0 === card }) else {
            return
        }
        cards.remove(at: cardIndex)
    }

    func addCard(_ card: T) {
        cards.append(card)
    }

    func addCard(_ card: T, at index: Int) {
        cards.insert(card, at: index)
    }

    func getCards() -> [T] {
        self.cards
    }
}
