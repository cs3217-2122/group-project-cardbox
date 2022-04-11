//
//  ExplodingKittensGameState.swift
//  CardBox
//
//  Created by Stuart Long on 11/4/22.
//

import Foundation

class ExplodingKittensGameState: GameState {
    internal var deck: CardCollection
    internal var gameplayArea: CardCollection

    override init() {
        self.deck = CardCollection()
        self.gameplayArea = CardCollection()
        super.init()
    }

    init(deck: CardCollection,
         players: PlayerCollection,
         playerHands: [UUID: CardCollection],
         gameplayArea: CardCollection,
         isWin: Bool,
         winner: Player?,
         state: GameModeState) {
        self.deck = deck
        self.gameplayArea = gameplayArea
        super.init(players: players, playerHands: playerHands, isWin: isWin, winner: winner, state: state)
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
        case deck
        case gameplayArea
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deck = try container.decode(CardCollection.self, forKey: .deck)
        self.gameplayArea = try container.decode(CardCollection.self, forKey: .gameplayArea)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deck, forKey: .deck)
        try container.encode(gameplayArea, forKey: .gameplayArea)
        try super.encode(to: encoder)
    }
}
