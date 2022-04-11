//
//  ExplodingKittensFirebaseAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//
import FirebaseFirestoreSwift
import Foundation

class ExplodingKittensFirebaseAdapter: FirebaseAdapter, Codable {

    @DocumentID var id: String? = UUID().uuidString
    var deck: ExplodingKittensCardCollectionAdapter
    var players: ExplodingKittensPlayerCollectionAdapter
    var playerHands: [ExplodingKittensCardCollectionAdapter]
    var gameplayArea: ExplodingKittensCardCollectionAdapter
    var state: GameModeState
    var isWin = false
    var winner: String
    var log: ExplodingKittensFirebaseLogger

    init(gameState: ExplodingKittensGameState) {
        self.deck = ExplodingKittensCardCollectionAdapter(gameState.deck)
        self.players = ExplodingKittensPlayerCollectionAdapter(gameState.players)
        self.gameplayArea = ExplodingKittensCardCollectionAdapter(gameState.gameplayArea)
        self.state = gameState.state
        self.isWin = gameState.isWin
        if let winner = gameState.winner {
            self.winner = winner.name
        } else {
            self.winner = ""
        }
        self.playerHands = []
        for index in 0..<gameState.players.count {
            if let player = gameState.players.getPlayerByIndex(index) {
                if let playerHand = gameState.playerHands[player.id] {
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
}
