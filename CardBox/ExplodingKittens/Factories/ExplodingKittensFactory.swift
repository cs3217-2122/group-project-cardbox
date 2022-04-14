//
//  ExplodingKittensFactory.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

class ExplodingKittensFactory: GameFactory {
    private init() {

    }

    static func initialiseGameState(gameState: GameState) {
        guard let gameState = gameState as? ExplodingKittensGameState else {
            return
        }

        if gameState.players.isEmpty {
            ExplodingKittensPlayerFactory.initialiseOfflinePlayers(gameState: gameState)
        }
        ExplodingKittensCardFactory.initialiseDeck(gameState: gameState)
        ExplodingKittensCardFactory.distributeCards(gameState: gameState)
    }

    static func generateGameState() -> GameState {
        ExplodingKittensGameState()
    }

}
