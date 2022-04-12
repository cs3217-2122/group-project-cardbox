//
//  MonopolyDealFactory.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

class MonopolyDealFactory: GameFactory {
    private init() {

    }

    static func initialiseGameState(gameState: GameState) {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return
        }

        if gameState.players.isEmpty {
            MonopolyDealPlayerFactory.initialiseOfflinePlayers(gameState: gameState)
        }

    }

    static func generateGameState() -> GameState {
        MonopolyDealGameState()
    }
}
