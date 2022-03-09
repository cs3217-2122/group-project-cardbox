class InitPlayerAction: Action {
    private let numPlayers: Int

    init(numPlayers: Int) {
        self.numPlayers = numPlayers
    }

    func generateGameEvents(gameRunner: GameRunnerProtocol) -> [GameEvent] {
        // Only can be used in non-init phase
        if gameRunner.state != .initialize {
            return []
        }

        return (1...numPlayers).map { i in
            .addPlayer(player: Player())
        }
    }
}
