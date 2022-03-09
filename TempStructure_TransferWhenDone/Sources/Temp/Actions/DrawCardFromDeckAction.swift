class DrawCardFromDeckAction: Action {
    func generateGameEvents(gameRunner: GameRunnerProtocol) -> [GameEvent] {
        guard let firstCard = gameRunner.deck.getFirstCard() else {
            return []
        }

        guard let currentPlayer = gameRunner.currentPlayer else {
            return []
        }

        return [
            .moveCardToPlayerFromDeck(card: firstCard, deck: gameRunner.deck, player: currentPlayer)
        ]
    }
}
