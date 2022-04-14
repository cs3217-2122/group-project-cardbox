//
//  GameEventTests+Stubs.swift
//  CardBoxTests
//
//  Created by Bryann Yeap Kok Keong on 3/4/22.
//

@testable import CardBox
import Foundation

extension GameEventTests {
    class CardStub: Card {

    }

    class PlayerStub: Player {

    }

    class GameRunnerStub: GameRunnerProtocol {
        func updateState(gameState: GameState) {
            
        }
        
        init() {
        }

        var isShowingPeek = false

        var localPendingRequests: [Request] = []

        var cardsDragging: [Card] = []

        var cardPreview: Card?

        var gameState = GameState(players: PlayerCollection(),
                                  playerHands: [:],
                                  isWin: false,
                                  winner: nil,
                                  state: .start,
                                  globalRequests: [],
                                  globalResponses: [])

        func setCardPreview(_ card: Card) {
            // Do nothing
        }

        func resetCardPreview() {
            // Do nothing
        }

        func setup() {
            deck = CardCollection(cards: [])
        }

        func onStartTurn() {
            deck = CardCollection(cards: [])
        }

        func onEndTurn() {
            deck = CardCollection(cards: [])
        }

        func onAdvanceNextPlayer() {
            guard let nextPlayer = getNextPlayer() else {
                return
            }

            players.setCurrentPlayer(nextPlayer)
        }

        func getWinner() -> Player? {
            nil
        }

        func getNextPlayer() -> Player? {
            guard !players.isEmpty else {
                return nil
            }

            let nextPlayer = players.getPlayerByIndex(max(players.currentPlayerIndex, players.count - 1))
            return nextPlayer
        }

        func checkWinningConditions() -> Bool {
            false
        }

        func notifyChanges(_ gameEvents: [GameEvent]) {
            // Do nothing
        }

        func updateState(_ gameRunner: GameRunnerProtocol) {
            // Do nothing
        }

    }

    static func generateSingleTargetCard() -> CardStub {
        CardStub(name: "single target card", typeOfTargettedCard: .targetSinglePlayerCard)
    }

    static func generateAllTargetCard() -> CardStub {
        CardStub(name: "all target card", typeOfTargettedCard: .targetAllPlayersCard)
    }

    static func generateNoneTargetCard() -> CardStub {
        CardStub(name: "no target card", typeOfTargettedCard: .noTargetCard)
    }

    static func cardCollectionsSame(cardCollection1: [Card], cardCollection2: [Card]) -> Bool {
        for i in 0..<cardCollection1.count {
            let card1 = cardCollection1[i]
            let card2 = cardCollection2[i]
            if card1 !== card2 {
                return false
            }
        }
        return true
    }

}
