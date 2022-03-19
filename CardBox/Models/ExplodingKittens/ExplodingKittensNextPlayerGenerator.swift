//
//  ExplodingKittensNextPlayerGenerator.swift
//  CardBox
//
//  Created by mactest on 17/03/2022.
//

struct ExplodingKittensNextPlayerGenerator: NextPlayerGenerator {
    func getNextPlayer(gameRunner: GameRunnerReadOnly) -> Player? {
        let players = gameRunner.players

        guard !players.isEmpty else {
            return nil
        }

        let currentIndex = players.currentPlayerIndex
        let totalCount = players.count
        var nextPlayer: Player?

        for i in 1...totalCount {
            let nextIndex = (currentIndex + i) % totalCount

            guard let player = players.getPlayerByIndex(nextIndex) else {
                continue
            }

            if player.isOutOfGame {
                continue
            }

            nextPlayer = player
            break
        }

        return nextPlayer
    }
}
