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

    internal var cardHeight = 200
    internal var cardWidth = 120

    @Published internal var gameState: GameState
    @Published internal var cardsDragging: [Card]
    @Published internal var cardsSelected: [Card]
    @Published internal var cardPreview: Card?

    internal var localPendingRequests: [Request]

    var deck: CardCollection {
        if let gameState = gameState as? MonopolyDealGameState {
            return gameState.deck
        } else {
            return MonopolyDealCardCollection()
        }
    }

    var gameplayArea: CardCollection {
        if let gameState = gameState as? MonopolyDealGameState {
            return gameState.gameplayArea
        } else {
            return MonopolyDealCardCollection()
        }
    }

    private var observers: [MonopolyDealGameRunnerObserver]

    init() {
        self.gameState = MonopolyDealFactory.generateGameState()
        self.cardsDragging = []
        self.cardsSelected = []
        self.localPendingRequests = []
        self.observers = []
    }

    // for online use (join Room)
    init(gameState: GameState, observer: MonopolyDealGameRunnerObserver) {
        self.gameState = gameState
        self.observers = [observer]
        self.cardsDragging = []
        self.cardsSelected = []
        self.localPendingRequests = []
    }

    // initialiser used by host game view model (create room)
    convenience init(host: Player, observer: MonopolyDealGameRunnerObserver) {
        self.init()
        self.gameState.addPlayer(player: MonopolyDealPlayer(name: host.name,
                                                            id: host.id,
                                                            isOutOfGame: host.isOutOfGame,
                                                            cardsPlayed: host.cardsPlayed))
        self.observers.append(observer)
    }

    func updateState(gameState: GameState) {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return
        }

        self.gameState.updateState(gameState: gameState)
        self.resolvePendingRequests()
        objectWillChange.send()
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

        let hand = getHandByPlayer(currentPlayer)

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
            return MonopolyDealCardCollection()
        }

        return gameState.playerHands[player.id] ?? MonopolyDealCardCollection()
    }

    func getPropertyAreaByPlayer(_ player: Player) -> MonopolyDealPlayerPropertyArea {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return MonopolyDealPlayerPropertyArea()
        }

        return gameState.playerPropertyArea[player.id] ?? MonopolyDealPlayerPropertyArea()
    }

    func getMoneyAreaByPlayer(_ player: Player) -> CardCollection {
        guard let gameState = gameState as? MonopolyDealGameState else {
            return MonopolyDealMoneyPile(cards: [])
        }

        return gameState.playerMoneyArea[player.id] ?? MonopolyDealMoneyPile(cards: [])
    }

    var allCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensConstants.allCardTypes
    }

    func notifyChanges(_ gameEvents: [GameEvent]) {
        objectWillChange.send()
        guard let gameState = gameState as? MonopolyDealGameState else {
            return
        }

        for observer in observers {
            print(observer)
            observer.notifyObserver(gameState, gameEvents)
        }
    }

    func setCardPreview(_ card: Card) {
        self.cardPreview = card
    }

    func resetCardPreview() {
        self.cardPreview = nil
    }

}
