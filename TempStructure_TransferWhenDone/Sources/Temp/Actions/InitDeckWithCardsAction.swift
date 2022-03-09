class InitDeckWithCardsAction: Action {
    private let cards: [Card]

    init(cards: [Card]) {
        self.cards = cards
    }

    func generateGameEvents(gameRunner: GameRunnerProtocol) -> [GameEvent] {
        let deck = gameRunner.deck

        return cards.map { card in
            .addCardToDeck(card: card, deck: deck)
        }
    }
}
