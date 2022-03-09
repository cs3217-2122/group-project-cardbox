class Player {
    private var hand: CardCollection

    init() {
        self.hand = CardCollection()
    }

    func addCard(_ card: Card) {
        self.hand.addCard(card)
    }
}
