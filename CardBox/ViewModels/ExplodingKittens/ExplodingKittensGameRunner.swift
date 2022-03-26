//
//  ExplodingKittensGameRunner.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

import SwiftUI
import Foundation

class ExplodingKittensGameRunner: GameRunnerProtocol, ObservableObject {
    @Published internal var deck: CardCollection
    @Published internal var players: PlayerCollection
    @Published internal var playerHands: [UUID: CardCollection]
    @Published internal var gameplayArea: CardCollection
    @Published internal var state: GameState

    @Published internal var cardPreview: Card?
    @Published internal var cardsPeeking: [Card]
    @Published internal var isShowingPeek = false
    @Published internal var isWin = false
    internal var winner: Player?

    init() {
        self.deck = CardCollection()
        self.players = PlayerCollection()
        self.playerHands = [:]
        self.gameplayArea = CardCollection()
        self.state = .initialize
        self.cardsPeeking = []
    }

    // To be overwritten
    func checkWinningConditions() -> Bool {
        false
    }

    func setup() {
        let numPlayers = 4
        let initialCardCount = 4

        let players = (1...numPlayers).map { i in
            ExplodingKittensPlayer(name: "Player " + i.description)
        }
        players.forEach { player in
            self.players.addPlayer(player)
            self.playerHands[player.id] = CardCollection()
        }

        self.playerHands.forEach { _, _ in
            let defuseCard = DefuseCard()
            deck.addCard(defuseCard)
        }

        let cards = initCards()
        cards.forEach { card in
            self.deck.addCard(card)
        }

        self.deck.shuffle()

        let topCards = self.deck.getTopNCards(n: numPlayers * initialCardCount)
        topCards.indices.forEach { i in
            guard let player = self.players.getPlayerByIndex(i % numPlayers) else {
                return
            }
            guard let playerDeck = self.playerHands[player.id] else {
                return
            }

            self.deck.removeCard(topCards[i])
            playerDeck.addCard(topCards[i])
        }
    }

    private func initCards() -> [Card] {
        var cards: [Card] = []

//        for _ in 0 ..< ExplodingKittensCardType.favor.initialFrequency {
//            cards.append(generateFavorCard())
//        }

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

//        for _ in 0 ..< ExplodingKittensCardType.random1.initialFrequency {
//            cards.append(generateRandom1Card())
//            cards.append(generateRandom2Card())
//            cards.append(generateRandom3Card())
//        }

        return cards
    }

    // To be overwritten
    func onStartTurn() {

    }

    // To be overwritten
    func onEndTurn() {

    }

    // To be overwritten
    func onAdvanceNextPlayer() {

    }

    // To be overwritten
    func getWinner() -> Player? {
        nil
    }

    // To be overwritten
    func getNextPlayer() -> Player? {
        guard !players.isEmpty else {
            return nil
        }

        guard let currentPlayer = players.currentPlayer as? ExplodingKittensPlayer else {
            return nil
        }

        let attackCount = currentPlayer.attackCount
        if attackCount > 0 {
            return currentPlayer
        }

        let currentIndex = players.currentPlayerIndex
        let totalCount = players.count
        var nextPlayer: Player?

        for i in 1...totalCount {
            let nextIndex = (currentIndex + i) % totalCount

            guard let player = players.getPlayerByIndex(nextIndex) else {
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
        self.playerHands[player.id]
    }

    var allCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensConstants.allCardTypes
    }

    func notifyChanges() {
        objectWillChange.send()
    }
}
