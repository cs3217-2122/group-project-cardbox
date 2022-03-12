struct DistributeCardsToPlayerAction: Action {
    let numCards: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        let players = gameRunner.players
        let numPlayers = players.count
        let cardsNeeded = 1...(numCards * numPlayers)

        let cards = cardsNeeded.compactMap { index in
            gameRunner.deck.getCardByIndex(index)
        }

        let moves: [GameEvent] = cards.indices.compactMap { index in
            guard let player = players.getPlayerByIndex(index % numPlayers) else {
                return nil
            }
            return MoveCardDeckToPlayerEvent(card: cards[index], player: player)
        }

        gameRunner.executeGameEvents(moves)
    }
}
