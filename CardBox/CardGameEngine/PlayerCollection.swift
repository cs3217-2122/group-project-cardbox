class PlayerCollection {
    private var players: [Player] = []
    private var currentPlayerIndex: Int

    convenience init() {
        self.init(players: [])
    }

    init(players: [Player]) {
        self.players = players
        self.currentPlayerIndex = 0
    }

    var count: Int {
        self.players.count
    }

    var currentPlayer: Player? {
        guard !players.isEmpty else {
            return nil
        }

        return self.players[self.currentPlayerIndex]
    }

    var nextPlayer: Player? {
        guard !players.isEmpty else {
            return nil
        }

        guard let nextIndex = self.getNextIndex() else {
            return nil
        }

        return self.players[nextIndex]
    }

    func addPlayer(_ player: Player) {
        self.players.append(player)
    }

    func setCurrentPlayer(_ player: Player) {
        guard let playerIndex = players.firstIndex(where: { $0 === player }) else {
            return
        }

        self.currentPlayerIndex = playerIndex
    }

    private func getNextIndex() -> Int? {
        guard !players.isEmpty else {
            return nil
        }

        return (self.currentPlayerIndex + 1) % self.players.count
    }

    func advanceToNextPlayer() {
        guard let nextIndex = getNextIndex() else {
            return
        }

        self.currentPlayerIndex = nextIndex
    }

    func getPlayerByIndex(_ index: Int) -> Player? {
        if index < 0 || index >= players.count {
            return nil
        }

        return players[index]
    }

    func getPlayers() -> [Player] {
        players
    }
}
