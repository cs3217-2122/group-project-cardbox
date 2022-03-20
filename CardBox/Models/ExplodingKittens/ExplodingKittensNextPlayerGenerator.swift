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

        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return nil
        }

        let attackCount = ExplodingKittensUtils.getAttackCount(player: currentPlayer)
        if attackCount > 0 {
            return currentPlayer
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
