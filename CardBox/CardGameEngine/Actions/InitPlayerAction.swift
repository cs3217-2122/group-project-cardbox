struct InitPlayerAction: Action {
    let numPlayers: Int
    let canPlayConditions: [PlayerPlayCondition]
    let cardCombos: [CardCombo]

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        // Only can be used in init phase
        guard gameRunner.state == .initialize else {
            return
        }

        let players: [Player] = (1...numPlayers).map { i in
            let player = Player(name: "Player " + i.description)

            canPlayConditions.forEach { condition in
                player.addCanPlayCondition(condition)
            }
            
            cardCombos.forEach { cardCombo in
                player.addCardCombo(cardCombo)
            }

            return player
        }

        let moves: [GameEvent] = players.map { player in
            AddPlayerEvent(player: player)
        } + [
            SetCurrentPlayerEvent(player: players[0])
        ]

        gameRunner.executeGameEvents(moves)
    }
}
