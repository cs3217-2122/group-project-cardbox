//
//  GameState.swift
//  CardBox
//
//  Created by Stuart Long on 11/4/22.
//
import Foundation

class GameState: Codable {
    internal var players: PlayerCollection
    internal var playerHands: [UUID: CardCollection]
    internal var state: GameModeState
    internal var isWin = false
    internal var winner: Player?

    init() {
        self.players = PlayerCollection()
        self.playerHands = [:]
        self.state = .initialize
    }

    init(players: PlayerCollection, playerHands: [UUID: CardCollection],
         isWin: Bool, winner: Player?, state: GameModeState) {
        self.players = players
        self.playerHands = playerHands
        self.isWin = isWin
        self.winner = winner
        self.state = state
    }

    func addPlayer(player: Player) {
        self.players.addPlayer(player)
        self.playerHands[player.id] = CardCollection()
    }

    func updateState(gameState: GameState) {
        if state == .start {
            self.players.updateState(gameState.players)
            self.updatePlayerHands(gameState.playerHands)
        } else {
            self.players = gameState.players
            self.playerHands = gameState.playerHands
        }
        self.isWin = gameState.isWin
        self.state = gameState.state
        self.winner = gameState.winner
    }

    func updatePlayerHands(_ newPlayerHands: [UUID: CardCollection]) {
        for (key, value) in newPlayerHands {
            guard let current = playerHands[key] else {
                continue
            }
            current.updateState(value)
        }
    }

}
