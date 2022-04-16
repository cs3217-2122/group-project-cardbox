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
    internal var globalRequests: RequestCollection
    internal var globalResponses: ResponseCollection

    init() {
        self.players = PlayerCollection()
        self.playerHands = [:]
        self.state = .initialize
        self.globalRequests = RequestCollection()
        self.globalResponses = ResponseCollection()
    }

    init(players: PlayerCollection, playerHands: [UUID: CardCollection],
         isWin: Bool, winner: Player?, state: GameModeState, globalRequests: [Request], globalResponses: [Response]) {
        self.players = players
        self.playerHands = playerHands
        self.isWin = isWin
        self.winner = winner
        self.state = state
        self.globalRequests = RequestCollection(globalRequests)
        self.globalResponses = ResponseCollection(globalResponses)
    }

    func addPlayer(player: Player) {
        self.players.addPlayer(player)
        self.playerHands[player.id] = CardCollection()
    }

    func updateState(gameState: GameState) {
        self.players.updateState(gameState.players)
        self.updatePlayerHands(gameState.playerHands)

        self.isWin = gameState.isWin
        self.state = gameState.state
        self.winner = gameState.winner
    }

    private func updatePlayerHands(_ newPlayerHands: [UUID: CardCollection]) {
        for (key, value) in newPlayerHands {
            if let current = playerHands[key] {
                current.updateState(value)
            } else {
                playerHands[key] = value
            }
        }
    }

    func addPlayerHand(playerId: UUID, cards: CardCollection) {
        self.playerHands[playerId] = cards
    }
}
