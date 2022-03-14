struct InitPlayerAction: Action {
    let numPlayers: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        // Only can be used in init phase
        guard gameRunner.state == .initialize else {
            return
        }

        let players: [Player] = (1...numPlayers).map { i in
            Player(name: "Player " + i.description)
        }

        let moves: [GameEvent] = players.map { player in
            AddPlayerEvent(player: player)
        } + [
            SetCurrentPlayerEvent(player: players[0])
        ]

        gameRunner.executeGameEvents(moves)
    }
}
