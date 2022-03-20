struct DistributeCardsToPlayerAction: Action {
    let numCards: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        guard numCards > 0 else {
            return
        }

        let players = gameRunner.players
        let numPlayers = players.count

        guard numPlayers > 0 else {
            return
        }

        let cardsNeeded = 0..<(numCards * numPlayers)

        let cards = cardsNeeded.compactMap { index in
            gameRunner.deck.getCardByIndex(index)
        }

        let moves: [GameEvent] = cards.indices.compactMap { index in
            guard let player = players.getPlayerByIndex(index % numPlayers),
                  !player.isOutOfGame else {
                return nil
            }
            return MoveCardDeckToPlayerEvent(card: cards[index], player: player)
        }

        gameRunner.executeGameEvents(moves)
    }
}
