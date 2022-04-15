//
//  SetCurrentPlayerEvent.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct SetCurrentPlayerEvent: GameEvent {
    let player: Player

    func updateRunner(gameRunner: GameRunnerProtocol) {
        gameRunner.gameState.players.setCurrentPlayer(player)
    }
}
