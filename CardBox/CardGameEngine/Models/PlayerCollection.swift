class PlayerCollection: Codable {
    private var players: [Player]
    private(set) var currentPlayerIndex: Int

    convenience init() {
        self.init(players: [])
    }

    init(players: [Player], currentPlayerIndex: Int = 0) {
        self.players = players
        self.currentPlayerIndex = currentPlayerIndex
    }

    var names: [String] {
        self.players.map { $0.name }
    }

    var count: Int {
        self.players.count
    }

    var isEmpty: Bool {
        self.players.isEmpty
    }

    var currentPlayer: Player? {
        guard !players.isEmpty else {
            return nil
        }

        return self.players[self.currentPlayerIndex]
    }

    func updateState(_ players: PlayerCollection) {
        self.players = players.players
        self.currentPlayerIndex = players.currentPlayerIndex
    }

    func addPlayer(_ player: Player) {
        guard !players.contains(where: { $0 === player }) else {
            return
        }

        self.players.append(player)
    }

    func setCurrentPlayer(_ player: Player) {
        guard let playerIndex = players.firstIndex(where: { $0 === player }) else {
            return
        }

        self.currentPlayerIndex = playerIndex
    }

    func getPlayerByIndex(_ index: Int) -> Player? {
        guard index >= 0 && index < players.count else {
            return nil
        }

        return players[index]
    }

    func getPlayers() -> [Player] {
        players
    }

    func getPlayerByIndexAfterCurrent(_ index: Int) -> Player? {
        guard index > 0 else {
            return nil
        }

        return players[(currentPlayerIndex + index) % self.players.count]
    }

    func remove(_ player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players.remove(at: index)
        }
    }

    func getPlayerByIndexAfterGiven(start: Int, increment: Int) -> Player? {
        guard increment > 0 else {
            return nil
        }

        return players[(start + increment) % self.players.count]
    }
}
