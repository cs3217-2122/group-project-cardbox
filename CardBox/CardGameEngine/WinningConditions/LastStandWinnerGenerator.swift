//
//  LastStandWinnerGenerator.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

struct LastStandWinnerGenerator: WinnerGenerator {
    func getWinner(gameRunner: GameRunnerReadOnly) -> Player? {
        gameRunner.players.getPlayers().first(where: { player in
            !player.isOutOfGame
        })
    }

}
