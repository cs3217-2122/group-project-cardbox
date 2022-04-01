//
//  ExplodingKittensFirebaseAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//
import FirebaseFirestoreSwift
import SwiftUI

class ExplodingKittensFirebaseAdapter: FirebaseAdapter {

    @DocumentID var id: String? = UUID().uuidString
    var deck: ExplodingKittensCardCollectionAdapter
    var players: PlayerCollection
    var playerHands: [ExplodingKittensCardCollectionAdapter]
    var gameplayArea: ExplodingKittensCardCollectionAdapter
    var state: GameState
    var isWin = false
    var winner: String

    init(explodingKittensGameRunner: ExplodingKittensGameRunner) {
        self.deck = ExplodingKittensCardCollectionAdapter(explodingKittensGameRunner.deck)
        self.players = explodingKittensGameRunner.players
        self.gameplayArea = ExplodingKittensCardCollectionAdapter(explodingKittensGameRunner.gameplayArea)
        self.state = explodingKittensGameRunner.state
        self.isWin = explodingKittensGameRunner.isWin
        if let winner = explodingKittensGameRunner.winner {
            self.winner = winner.name
        } else {
            self.winner = ""
        }
        self.playerHands = []
        for index in 0..<players.count {
            if let player = players.getPlayerByIndex(index) {
                if let playerHand = explodingKittensGameRunner.playerHands[player.id] {
                    self.playerHands.append(ExplodingKittensCardCollectionAdapter(playerHand))
                }
            }
        }
        super.init()
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case deck
        case players
        case playerHands
        case gameplayArea
        case state
        case isWin
        case winner
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(DocumentID<String>.self, forKey: .id)
          .wrappedValue
        self.deck = try container.decode(ExplodingKittensCardCollectionAdapter.self, forKey: .deck)
        self.players = try container.decode(PlayerCollection.self, forKey: .players)
        self.playerHands = try container.decode([ExplodingKittensCardCollectionAdapter].self, forKey: .playerHands)
        self.gameplayArea = try container.decode(ExplodingKittensCardCollectionAdapter.self, forKey: .gameplayArea)
        self.state = try container.decode(GameState.self, forKey: .state)
        self.isWin = try container.decode(Bool.self, forKey: .isWin)
        self.winner = try container.decode(String.self, forKey: .winner)
        super.init()
    }

    override public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
        try container.encode(deck, forKey: .deck)
        try container.encode(players, forKey: .players)
        try container.encode(playerHands, forKey: .playerHands)
        try container.encode(gameplayArea, forKey: .gameplayArea)
        try container.encode(state, forKey: .state)
        try container.encode(isWin, forKey: .isWin)
        try container.encode(winner, forKey: .winner)
    }
}
