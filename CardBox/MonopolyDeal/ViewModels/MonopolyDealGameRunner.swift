//
//  MonopolyDealGameRunner.swift
//  CardBox
//
//  Created by Temp on 31.03.2022.
//

import SwiftUI
import Foundation

class MonopolyDealGameRunner: MonopolyDealGameRunnerProtocol, ObservableObject {
    static let winningPropertySetCount = 3
    static let drawCards = 2

    @Published internal var gameState: GameState
    @Published internal var cardsDragging: [Card]
    @Published internal var cardsSelected: [Card]
    @Published internal var cardPreview: Card?

    internal var localPendingRequests: [Request]


    var deck: CardCollection {
        if let gameState = gameState as? MonopolyDealGameState {
            return gameState.deck
        } else {
            return CardCollection()
        }
    }

    var gameplayArea: CardCollection {
        if let gameState = gameState as? MonopolyDealGameState {
            return gameState.gameplayArea
        } else {
            return CardCollection()
        }
    }

    init() {
        self.gameState = MonopolyDealFactory.generateGameState()
        self.cardsDragging = []
        self.cardsSelected = []
        self.localPendingRequests = []
    }

    func updateState(_ gameRunner: GameRunnerProtocol) {

    }

    func updateState(gameState: GameState) {

    }

    func setup() {
        MonopolyDealFactory.initialiseGameState(gameState: self.gameState)
        notifyChanges([])
    }

    func onStartTurn() {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return
        }
        guard let currentPlayer = gameState.players.currentPlayer as? MonopolyDealPlayer else {
            return
        }

        let drawCards = gameState.deck.getTopNCards(n: MonopolyDealGameRunner.drawCards)

        let hand = getHandByPlayer(currentPlayer) ?? CardCollection()

        executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: drawCards, fromDeck: gameState.deck, toDeck: hand)
        ])
    }

    func onEndTurn() {
    }

    func onAdvanceNextPlayer() {
        guard let currentPlayer = gameState.players.currentPlayer as? MonopolyDealPlayer else {
            return
        }
        currentPlayer.resetPlayCount()
    }

    func checkWinningConditions() -> Bool {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return false
        }

        return gameState.players.getPlayers().filter { _ in
            gameState.playerPropertyArea.count == MonopolyDealGameRunner.winningPropertySetCount
        }.count >= 1
    }

    func getWinner() -> Player? {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return nil
        }

        return gameState.players.getPlayers().filter { _ in
            gameState.playerPropertyArea.count == MonopolyDealGameRunner.winningPropertySetCount
        }[0]
    }

    func getNextPlayer() -> Player? {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return nil
        }

        guard !gameState.players.isEmpty else {
            return nil
        }

        let currentIndex = gameState.players.currentPlayerIndex
        let totalCount = gameState.players.count
        var nextPlayer: Player?

        for i in 1...totalCount {
            let nextIndex = (currentIndex + i) % totalCount

            guard let player = gameState.players.getPlayerByIndex(nextIndex) else {
                continue
            }

            nextPlayer = player
            break
        }

        return nextPlayer
    }


    func getHandByPlayer(_ player: Player) -> CardCollection {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return CardCollection()
        }

        return gameState.playerHands[player.id] ?? CardCollection()
    }

    func getPropertyAreaByPlayer(_ player: Player) -> MonopolyDealPlayerPropertyArea {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return MonopolyDealPlayerPropertyArea()
        }

        return gameState.playerPropertyArea[player.id] ?? MonopolyDealPlayerPropertyArea()
    }

    func getMoneyAreaByPlayer(_ player: Player) -> CardCollection {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return CardCollection()
        }

        return gameState.playerMoneyArea[player.id] ?? CardCollection()
    }

    var allCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensConstants.allCardTypes
    }

    func notifyChanges(_ gameEvents: [GameEvent]) {
        objectWillChange.send()
        // TODO: notify observers
    }

    func setCardPreview(_ card: Card) {
        self.cardPreview = card
    }

    func resetCardPreview() {
        self.cardPreview = nil
    }

}
