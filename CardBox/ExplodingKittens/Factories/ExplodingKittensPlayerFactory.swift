//
//  ExplodingKittensPlayerFactory.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

class ExplodingKittensPlayerFactory: PlayerFactory {
    private init() {

    }

    static func initialiseOfflinePlayers(gameState: GameState) {
        let numPlayers = 4

        let players = (1...numPlayers).map { i in
            ExplodingKittensPlayer(name: "Player " + i.description)
        }
        players.forEach { player in
            gameState.players.addPlayer(player)
            gameState.playerHands[player.id] = CardCollection()
        }
    }

    static func getPlayer(array: UnkeyedDecodingContainer) -> Player? {
        var arrayCopy = array
        return try? arrayCopy.decode(ExplodingKittensPlayer.self)
    }
}
