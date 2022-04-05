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

    @Published internal var deck: CardCollection
    @Published internal var players: PlayerCollection
    @Published internal var playerHands: [UUID: CardCollection]
    @Published internal var playerPropertyArea: [UUID: MonopolyDealPlayerPropertyArea]
    @Published internal var playerMoneyArea: [UUID: CardCollection]
    @Published internal var gameplayArea: CardCollection

    @Published internal var cardsDragging: [Card]
    @Published internal var cardPreview: Card?
    @Published internal var isWin = false
    internal var winner: Player?
    @Published internal var deckPositionRequest: CardPositionRequest
    @Published internal var cardTypeRequest: CardTypeRequest

    init() {
        self.deck = CardCollection()
        self.players = PlayerCollection()
        self.playerHands = [:]
        self.gameplayArea = CardCollection()
        self.playerPropertyArea = [:]
        self.playerMoneyArea = [:]
        self.cardsDragging = []
        self.deckPositionRequest = CardPositionRequest()
        self.cardTypeRequest = CardTypeRequest()
    }

    func setup() {
        let numPlayers = 4
        let initialCardCount = 4

        let players = (1...numPlayers).map { i in
            MonopolyDealPlayer(name: "Player " + i.description)
        }
        players.forEach { player in
            self.players.addPlayer(player)
            self.playerHands[player.id] = CardCollection()
            self.playerPropertyArea[player.id] = MonopolyDealPlayerPropertyArea()
            self.playerMoneyArea[player.id] = CardCollection()
        }

        let cards = initCards()
        cards.forEach { card in
            self.deck.addCard(card)
        }

        if !CommandLine.arguments.contains("-UITest_MonopolyDeal") {
            self.deck.shuffle()
        }

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

    private func initCards() -> [MonopolyDealCard] {
        var cards: [MonopolyDealCard] = []

        let moneyCardValues: [MoneyCardValue] = [.one, .two, .three, .four, .five, .ten]

        for moneyCardValue in moneyCardValues {
            for _ in 0 ..< moneyCardValue.initialFrequency {
                cards.append(MoneyCard(value: moneyCardValue))
            }
        }

        for _ in 0 ..< MonopolyDealCardType.passGo  .initialFrequency {
            cards.append(PassGoCard())
        }

        for _ in 0 ..< MonopolyDealCardType.birthday  .initialFrequency {
            cards.append(BirthdayCard())
        }

        for _ in 0 ..< MonopolyDealCardType.dealBreaker.initialFrequency {
            cards.append(DealBreakerCard())
        }

        for _ in 0 ..< MonopolyDealCardType.house.initialFrequency {
            cards.append(HouseCard())
        }

        return cards
    }

    func onStartTurn() {
        guard let currentPlayer = players.currentPlayer as? MonopolyDealPlayer else {
            return
        }

        let drawCards = deck.getTopNCards(n: MonopolyDealGameRunner.drawCards)

        let hand = getHandByPlayer(currentPlayer)

        executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: drawCards, fromDeck: deck, toDeck: hand)
        ])
    }

    func onEndTurn() {
    }

    func onAdvanceNextPlayer() {
        guard let currentPlayer = players.currentPlayer as? MonopolyDealPlayer else {
            return
        }
        currentPlayer.resetPlayCount()
    }

    func checkWinningConditions() -> Bool {
        players.getPlayers().filter { _ in
            playerPropertyArea.count == MonopolyDealGameRunner.winningPropertySetCount
        }.count >= 1
    }

    func getWinner() -> Player? {
        players.getPlayers().filter { _ in
            playerPropertyArea.count == MonopolyDealGameRunner.winningPropertySetCount
        }[0]
    }

    func getNextPlayer() -> Player? {
        guard !players.isEmpty else {
            return nil
        }

        let currentIndex = players.currentPlayerIndex
        let totalCount = players.count
        var nextPlayer: Player?

        for i in 1...totalCount {
            let nextIndex = (currentIndex + i) % totalCount

            guard let player = players.getPlayerByIndex(nextIndex) else {
                continue
            }

            nextPlayer = player
            break
        }

        return nextPlayer
    }

    func getHandByPlayer(_ player: Player) -> CardCollection {
        self.playerHands[player.id] ?? CardCollection()
    }

    func getPropertyAreaByPlayer(_ player: Player) -> MonopolyDealPlayerPropertyArea {
        self.playerPropertyArea[player.id] ?? MonopolyDealPlayerPropertyArea()
    }

    func getMoneyAreaByPlayer(_ player: Player) -> CardCollection {
        self.playerMoneyArea[player.id] ?? CardCollection()
    }

    var allCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensConstants.allCardTypes
    }

    func notifyChanges(_ gameEvents: [GameEvent]) {
        objectWillChange.send()
        // TODO: notify observers
    }

    func updateState(_ gameRunner: GameRunnerProtocol) {
        guard let mdGameRunner = gameRunner as? MonopolyDealGameRunner else {
            return
        }

        // TODO: Networking update
    }

    func setCardPreview(_ card: Card) {
        self.cardPreview = card
    }

    func resetCardPreview() {
        self.cardPreview = nil
    }

}
