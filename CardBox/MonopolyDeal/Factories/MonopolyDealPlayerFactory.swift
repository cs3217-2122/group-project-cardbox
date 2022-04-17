//
//  MonopolyDealPlayerFactory.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

class MonopolyDealPlayerFactory: PlayerFactory {
    private init() {

    }

    static func initialiseOfflinePlayers(gameState: GameState) {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return
        }

        let numPlayers = 4

        let players = (1...numPlayers).map { i in
            MonopolyDealPlayer(name: "Player \(i.description)")
        }
        players.forEach { player in
            gameState.players.addPlayer(player)
            gameState.playerHands[player.id] = CardCollection()
            gameState.playerPropertyArea[player.id] = MonopolyDealPlayerPropertyArea()
            gameState.playerMoneyArea[player.id] = MonopolyDealMoneyPile()
        }
    }
}
