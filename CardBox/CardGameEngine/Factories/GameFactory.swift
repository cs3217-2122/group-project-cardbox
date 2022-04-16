//
//  GameFactory.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

protocol GameFactory {
    static func generateGameState() -> GameState
    static func initialiseGameState(gameState: GameState)

    // other decoding functions here?
}
