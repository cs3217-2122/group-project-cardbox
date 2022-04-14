//
//  ExplodingKittensGameState.swift
//  CardBox
//
//  Created by Stuart Long on 11/4/22.
//

import Foundation

class ExplodingKittensGameState: GameState {
    internal var deck: ExplodingKittensCardCollection
    internal var gameplayArea: ExplodingKittensCardCollection

    override init() {
        self.deck = ExplodingKittensCardCollection()
        self.gameplayArea = ExplodingKittensCardCollection()
        super.init()
    }

    init(deck: ExplodingKittensCardCollection,
         players: ExplodingKittensPlayerCollection,
         playerHands: [UUID: ExplodingKittensCardCollection],
         gameplayArea: ExplodingKittensCardCollection,
         isWin: Bool,
         winner: ExplodingKittensPlayer?,
         state: GameModeState,
         globalRequests: [Request],
         globalResponses: [Response]) {
        self.deck = deck
        self.gameplayArea = gameplayArea
        super.init(players: players,
                   playerHands: playerHands,
                   isWin: isWin,
                   winner: winner,
                   state: state,
                   globalRequests: globalRequests,
                   globalResponses: globalResponses)
    }

    override func updateState(gameState: GameState) {
        if let gameState = gameState as? ExplodingKittensGameState {
            if gameState.state == .start {
                self.deck.updateState(gameState.deck)
                self.gameplayArea.updateState(gameState.gameplayArea)
            } else {
                self.deck = gameState.deck
                self.gameplayArea = gameState.gameplayArea
            }
        }

        super.updateState(gameState: gameState)
    }

    private enum CodingKeys: String, CodingKey {
        case players
        case playerHands
        case state
        case isWin
        case winner
        case deck
        case gameplayArea
        case globalRequests
        case globalResponses
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deck = try container.decode(ExplodingKittensCardCollection.self, forKey: .deck)
        self.gameplayArea = try container.decode(ExplodingKittensCardCollection.self, forKey: .gameplayArea)
        let players = try container.decode(ExplodingKittensPlayerCollection.self, forKey: .players)
        let playerHands = try container.decode([UUID: ExplodingKittensCardCollection].self, forKey: .playerHands)
        let state = try container.decode(GameModeState.self, forKey: .state)
        let isWin = try container.decode(Bool.self, forKey: .isWin)
        let winner: ExplodingKittensPlayer?
        if container.contains(.winner) {
            winner = try container.decode(ExplodingKittensPlayer.self, forKey: .winner)
        } else {
            winner = nil
        }
        let globalRequests = try container.decode([Request].self, forKey: .globalRequests)
        let globalResponses = try container.decode([Response].self, forKey: .globalResponses)
//        let winner = try container.decode(ExplodingKittensPlayer?.self, forKey: .winner)

        super.init(players: players,
                   playerHands: playerHands,
                   isWin: isWin,
                   winner: winner,
                   state: state,
                   globalRequests: globalRequests,
                   globalResponses: globalResponses)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deck, forKey: .deck)
        try container.encode(gameplayArea, forKey: .gameplayArea)
        try super.encode(to: encoder)
    }
}
