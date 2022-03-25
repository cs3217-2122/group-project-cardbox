class PlayerCollection<T: Player> {
    private var players: [T]
    private(set) var currentPlayerIndex: Int

    convenience init() {
        self.init(players: [])
    }

    init(players: [T]) {
        self.players = players
        self.currentPlayerIndex = 0
    }

    var count: Int {
        self.players.count
    }

    var isEmpty: Bool {
        self.players.isEmpty
    }

    var currentPlayer: T? {
        guard !players.isEmpty else {
            return nil
        }

        return self.players[self.currentPlayerIndex]
    }

    func addPlayer(_ player: T) {
        guard !players.contains(player) else {
            return
        }

        self.players.append(player)
    }

    func setCurrentPlayer(_ player: T) {
        guard let playerIndex = players.firstIndex(player) else {
            return
        }

        self.currentPlayerIndex = playerIndex
    }

    func getPlayerByIndex(_ index: Int) -> T? {
        guard index >= 0 && index < players.count else {
            return nil
        }

        return players[index]
    }

    func getPlayers() -> [T] {
        players
    }

    func getPlayerByIndexAfterCurrent(_ index: Int) -> T? {
        guard index > 0 else {
            return nil
        }

        return players[(currentPlayerIndex + index) % self.players.count]
    }
}
