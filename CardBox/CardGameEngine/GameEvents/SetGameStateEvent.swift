//
//  SetGameStateEvent.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

struct SetGameStateEvent: GameEvent {
    let gameState: GameState

    func updateRunner(gameRunner: GameRunner) {

        gameRunner.setGameState(gameState: gameState)
    }
}
