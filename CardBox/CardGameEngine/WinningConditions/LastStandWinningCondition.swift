//
//  LastStandWinningCondition.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

struct LastStandWinningCondition: WinningCondition {
    func evaluate(gameRunner: GameRunnerReadOnly) -> Bool {
        let survivingPlayer = gameRunner.players.getPlayers().filter { !$0.isOutOfGame }

        if survivingPlayer.count > 1 {
            return false
        }

        return true
    }
}
