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
    var players: ExplodingKittensPlayerCollectionAdapter
    var playerHands: [ExplodingKittensCardCollectionAdapter]
    var gameplayArea: ExplodingKittensCardCollectionAdapter
    var state: GameState
    var isWin = false
    var winner: String
    var log: ExplodingKittensFirebaseLogger

    init(explodingKittensGameRunner: ExplodingKittensGameRunner) {
        self.deck = ExplodingKittensCardCollectionAdapter(explodingKittensGameRunner.deck)
        self.players = ExplodingKittensPlayerCollectionAdapter(explodingKittensGameRunner.players)
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
        self.log = ExplodingKittensFirebaseLogger()
    }

    func toGameRunner(
        observer: ExplodingKittensGameRunnerObserver) -> ExplodingKittensGameRunner {

            // generate playerHands, winner
            var winnerPlayer: ExplodingKittensPlayer?

            if !winner.isEmpty {
                if let winnerPlayerAdapter = players.getExplodingKittensPlayerAdapterByName(name: winner) {
                    winnerPlayer = winnerPlayerAdapter.gamePlayer
                }
            }

            var playerHandsMapping: [UUID: CardCollection] = [:]

            for index in 0 ..< playerHands.count {
                guard let player = players.getPlayerByIndex(index) else {
                    continue
                }

                playerHandsMapping[player.id] = playerHands[index].cardCollection
            }

            return ExplodingKittensGameRunner(
                deck: deck.cardCollection,
                players: players.playerCollection,
                playerHands: playerHandsMapping,
                gameplayArea: gameplayArea.cardCollection,
                state: state,
                isWin: isWin,
                winner: winnerPlayer,
                observer: observer)
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
        case log
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(DocumentID<String>.self, forKey: .id)
          .wrappedValue
        self.deck = try container.decode(ExplodingKittensCardCollectionAdapter.self, forKey: .deck)
        self.players = try container.decode(ExplodingKittensPlayerCollectionAdapter.self, forKey: .players)
        self.playerHands = try container.decode([ExplodingKittensCardCollectionAdapter].self, forKey: .playerHands)
        self.gameplayArea = try container.decode(ExplodingKittensCardCollectionAdapter.self, forKey: .gameplayArea)
        self.state = try container.decode(GameState.self, forKey: .state)
        self.isWin = try container.decode(Bool.self, forKey: .isWin)
        self.winner = try container.decode(String.self, forKey: .winner)
        self.log = try container.decode(ExplodingKittensFirebaseLogger.self, forKey: .log)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deck, forKey: .deck)
        try container.encode(players, forKey: .players)
        try container.encode(playerHands, forKey: .playerHands)
        try container.encode(gameplayArea, forKey: .gameplayArea)
        try container.encode(state, forKey: .state)
        try container.encode(isWin, forKey: .isWin)
        try container.encode(winner, forKey: .winner)
        try container.encode(log, forKey: .log)
    }
}
