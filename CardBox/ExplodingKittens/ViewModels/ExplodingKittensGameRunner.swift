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
    @Published internal var isShowingPeek = false
    @Published internal var deckPositionRequest: CardPositionRequest
    @Published internal var cardTypeRequest: CardTypeRequest

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
        self.gameState = ExplodingKittensGameState()
        self.cardsPeeking = []
        self.deckPositionRequest = CardPositionRequest()
        self.observers = []
        self.cardTypeRequest = CardTypeRequest()
        self.cardsDragging = []
    }

    // for online use
    init(deck: CardCollection,
         players: PlayerCollection,
         playerHands: [UUID: CardCollection],
         gameplayArea: CardCollection,
         state: GameModeState,
         isWin: Bool,
         winner: Player?,
         observer: ExplodingKittensGameRunnerObserver) {
        self.gameState = ExplodingKittensGameState(deck: deck,
                                                   players: players,
                                                   playerHands: playerHands,
                                                   gameplayArea: gameplayArea,
                                                   isWin: isWin,
                                                   winner: winner,
                                                   state: state)
        self.cardsPeeking = []
        self.deckPositionRequest = CardPositionRequest()
        self.observers = [observer]
        self.cardTypeRequest = CardTypeRequest()
        self.cardsDragging = []
    }

    // initialiser used by host game view model
    convenience init(host: Player, observer: ExplodingKittensGameRunnerObserver) {
        self.init()
        self.gameState.addPlayer(player: ExplodingKittensPlayer(name: host.name,
                                                                id: host.id,
                                                                isOutOfGame: host.isOutOfGame,
                                                                cardsPlayed: host.cardsPlayed))
        self.observers.append(observer)
//        self.gameState.addPlayerHands(player: host.id, hand: CardCollection())
    }

    func updateState(_ gameRunner: GameRunnerProtocol) {
        guard let explodingKittensGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        gameState.updateState(gameState: explodingKittensGameRunner.gameState)
        self.observers = explodingKittensGameRunner.observers
    }

    // TODO: create setup for online to inject online players
    func setup() {
        guard let gameState = gameState as? ExplodingKittensGameState else {
            return
        }

        let numPlayers = 4
        let initialCardCount = 4

        if gameState.players.isEmpty {
            let players = (1...numPlayers).map { i in
                ExplodingKittensPlayer(name: "Player " + i.description)
            }
            players.forEach { player in
                self.gameState.players.addPlayer(player)
                self.gameState.playerHands[player.id] = CardCollection()
            }
        }

        self.gameState.playerHands.forEach { _, hand in
            let defuseCard = DefuseCard()
            hand.addCard(defuseCard)
        }

        let cards = initCards()
        cards.forEach { card in
            gameState.deck.addCard(card)
        }

        if !CommandLine.arguments.contains("-UITest_ExplodingKittens") {
            gameState.deck.shuffle()
        }

        let topCards = gameState.deck.getTopNCards(n: numPlayers * initialCardCount)
        topCards.indices.forEach { i in
            guard let player = self.gameState.players.getPlayerByIndex(i % numPlayers) else {
                return
            }
            guard let playerDeck = self.gameState.playerHands[player.id] else {
                return
            }

            gameState.deck.removeCard(topCards[i])
            playerDeck.addCard(topCards[i])
            playerDeck.shuffle()
        }

        let bombs = (1...(numPlayers - 1)).map { _ in
            BombCard()
        }
        bombs.forEach { bomb in
            gameState.deck.addCard(bomb)
        }

        if !CommandLine.arguments.contains("-UITest_ExplodingKittens") {
            gameState.deck.shuffle()
        }
    }

    private func initCards() -> [ExplodingKittensCard] {
        var cards: [ExplodingKittensCard] = []

        for _ in 0 ..< ExplodingKittensCardType.favor.initialFrequency {
            cards.append(FavorCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.attack.initialFrequency {
            cards.append(AttackCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.shuffle.initialFrequency {
            cards.append(ShuffleCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.skip.initialFrequency {
            cards.append(SkipCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.seeTheFuture.initialFrequency {
            cards.append(SeeTheFutureCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.random1.initialFrequency {
            cards.append(RandomCard(name: "Random 1", type: .random1))
            cards.append(RandomCard(name: "Random 2", type: .random2))
            cards.append(RandomCard(name: "Random 3", type: .random3))
        }

        return cards
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

    func getHandByPlayer(_ player: Player) -> CardCollection? {
        self.gameState.playerHands[player.id]
    }

    var allCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensConstants.allCardTypes
    }

    func notifyChanges(_ gameEvents: [GameEvent]) {
        objectWillChange.send()
        for observer in observers {
            print(observer)
            observer.notifyObserver(self, gameEvents)
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
