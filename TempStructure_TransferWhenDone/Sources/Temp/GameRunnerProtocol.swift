class GameRunner<T: Card, V: Player> {
    var decks: [Int: [CardCollection<T>]]
    var players: PlayerCollection<V>

    init() {
        self.decks = [:]
        self.players = PlayerCollection<V>()
    }

    func getPlayer(index: Int) -> V? {
        return players.getPlayerByIndex(index)
    }

    func getDeck(index: Int, for forIndex: Int) -> CardCollection<T>? {
        guard let forDeck = decks[forIndex] else {
            return nil
        }

        return forDeck[index]
    }
}
