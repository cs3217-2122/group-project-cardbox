class AddCardToDeckAction: Action {
    private var card: Card

    init(card: Card) {
        self.card = card
    }

    func generateGameEvents(gameRunner: GameRunnerProtocol) -> [GameEvent] {
        return [
            .addCardToDeck(card: card, deck: gameRunner.deck)
        ]
    }
}
