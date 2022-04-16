//
//  ExplodingKittensGameRunner.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

import SwiftUI
import Foundation

class ExplodingKittensGameRunner: ExplodingKittensGameRunnerProtocol, ObservableObject {
    @Published internal var gameState: GameState
    @Published internal var cardPreview: Card?
    @Published internal var cardsPeeking: [Card]
    @Published internal var cardsDragging: [Card]
    @Published internal var cardsSelected: [Card]
    @Published internal var isShowingPeek = false
    internal var localPendingRequests: [Request]

    var deck: CardCollection {
        if let gameState = gameState as? ExplodingKittensGameState {
            return gameState.deck
        } else {
            return CardCollection()
        }
    }

    var gameplayArea: CardCollection {
        if let gameState = gameState as? ExplodingKittensGameState {
            return gameState.gameplayArea
        } else {
            return CardCollection()
        }
    }

    private var observers: [ExplodingKittensGameRunnerObserver]

    // for offline use
    init() {
        self.gameState = ExplodingKittensFactory.generateGameState()
        self.cardsPeeking = []
        self.observers = []
        self.cardsDragging = []
        self.cardsSelected = []
        self.localPendingRequests = []
    }

    // for online use (join Room)
    init(gameState: GameState, observer: ExplodingKittensGameRunnerObserver) {
        self.gameState = gameState
        self.cardsPeeking = []
        self.observers = [observer]
        self.cardsDragging = []
        self.cardsSelected = []
        self.localPendingRequests = []
    }

    // initialiser used by host game view model (create room)
    convenience init(host: Player, observer: ExplodingKittensGameRunnerObserver) {
        self.init()
        self.gameState.addPlayer(player: ExplodingKittensPlayer(name: host.name,
                                                                id: host.id,
                                                                isOutOfGame: host.isOutOfGame,
                                                                cardsPlayed: host.cardsPlayed))
        self.observers.append(observer)
    }

    func updateState(_ gameRunner: GameRunnerProtocol) {
        guard let explodingKittensGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        gameState.updateState(gameState: explodingKittensGameRunner.gameState)
        self.observers = explodingKittensGameRunner.observers
    }

    func updateState(gameState: GameState) {
        guard let gameState = gameState as? ExplodingKittensGameState else {
            return
        }

        self.gameState.updateState(gameState: gameState)
        self.resolvePendingRequests()
        objectWillChange.send()
    }

    // TODO: create setup for online to inject online players
    func setup() {
        ExplodingKittensFactory.initialiseGameState(gameState: self.gameState)
        notifyChanges([])
    }

    // To be overwritten
    func onStartTurn() {

    }

    // To be overwritten
    func onEndTurn() {
        guard let gameState = gameState as? ExplodingKittensGameState else {
            return
        }

        let top = gameState.deck.getTopNCards(n: 1)

        guard !top.isEmpty else {
            return
        }

        guard let currentPlayer = gameState.players.currentPlayer else {
            return
        }

        guard let hand = gameState.playerHands[currentPlayer.id] else {
            return
        }

        hand.addCard(top[0])
        gameState.deck.removeCard(top[0])

        top[0].onDraw(gameRunner: self, player: currentPlayer)
    }

    // To be overwritten
    func onAdvanceNextPlayer() {
        guard let currentPlayer = gameState.players.currentPlayer as? ExplodingKittensPlayer else {
            return
        }
        currentPlayer.decrementAttackCount()
    }

    // To be overwritten
    func checkWinningConditions() -> Bool {
        gameState.players.getPlayers().filter { !$0.isOutOfGame }.count == 1
    }

    // To be overwritten
    func getWinner() -> Player? {
        gameState.players.getPlayers().filter { !$0.isOutOfGame }[0]
    }

    // To be overwritten
    func getNextPlayer() -> Player? {
        guard !gameState.players.isEmpty else {
            return nil
        }

        guard let currentPlayer = gameState.players.currentPlayer as? ExplodingKittensPlayer else {
            return nil
        }

        let attackCount = currentPlayer.attackCount
        if attackCount > 0 {
            return currentPlayer
        }

        let currentIndex = gameState.players.currentPlayerIndex
        let totalCount = gameState.players.count
        var nextPlayer: Player?

        for i in 1...totalCount {
            let nextIndex = (currentIndex + i) % totalCount

            guard let player = gameState.players.getPlayerByIndex(nextIndex) else {
                continue
            }

            if player.isOutOfGame {
                continue
            }

            nextPlayer = player
            break
        }

        return nextPlayer
    }

    func getHandByPlayer(_ player: Player) -> CardCollection {
        guard let gameState = gameState as? ExplodingKittensGameState else {
            return CardCollection()
        }

        return gameState.playerHands[player.id] ?? CardCollection()
    }

    var allCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensConstants.allCardTypes
    }

    func notifyChanges(_ gameEvents: [GameEvent]) {
        objectWillChange.send()
        guard let gameState = gameState as? ExplodingKittensGameState else {
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

    func setCardsPeeking(cards: [Card]) {
        self.cardsPeeking = cards
        self.isShowingPeek = true
    }
}
