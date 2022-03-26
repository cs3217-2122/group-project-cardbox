//
//  GameRunner.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

import SwiftUI

class GameRunner: GameRunnerProtocol, ObservableObject {
    @Published internal var deck: CardCollection
    @Published internal var players: PlayerCollection
    @Published internal var gameplayArea: CardCollection
    @Published internal var state: GameState
    @Published internal var cardPreview: Card?
    @Published internal var cardsPeeking: [Card]
    @Published internal var isShowingPeek = false
    @Published internal var isWin = false
    internal var winner: Player?

    // Exploding kitten specific variables
    @Published internal var isShowingDeckPositionRequest = false
    @Published internal var isShowingPlayerHandPositionRequest = false
    @Published internal var isShowingCardTypeRequest = false
    internal var deckPositionRequestArgs: DeckPositionRequestArgs?
    internal var playerHandPositionRequestArgs: PlayerHandPositionRequestArgs?
    internal var cardTypeRequestArgs: CardTypeRequestArgs?

    init() {
        self.deck = CardCollection()
        self.gameplayArea = CardCollection()
        self.players = PlayerCollection()
        self.state = .initialize
        self.cardsPeeking = []
    }

    // To be overwritten
    func checkWinningConditions() -> Bool {
        false
    }

    // To be overwritten
    func setup() {

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
        nil
    }

    func executeGameEvents(_ gameEvents: [GameEvent]) {
        gameEvents.forEach { gameEvent in
            gameEvent.updateRunner(gameRunner: self)
        }
        notifyChanges()

        if checkWinningConditions() {
            self.isWin = true
            self.winner = getWinner()
        }
    }

    func setGameState(gameState: GameState) {
        self.state = gameState
    }

    func notifyChanges() {
        objectWillChange.send()
    }

    func endPlayerTurn() {
//        ActionDispatcher.runAction(EndTurnAction(), on: self)
    }

    func setCardsPeeking(cards: [Card]) {
        self.cardsPeeking = cards
        self.isShowingPeek = true
    }

    func showDeckPositionRequest() {
        self.isShowingDeckPositionRequest = true
    }

    func hideDeckPositionRequest() {
        self.isShowingDeckPositionRequest = false
    }

    func toggleDeckPositionRequest(to isShowingRequest: Bool) {
        self.isShowingDeckPositionRequest = isShowingRequest
    }

    func setDeckPositionRequestArgs(_ args: DeckPositionRequestArgs) {
        self.deckPositionRequestArgs = args
    }

    func togglePlayerHandPositionRequest(to isShowingRequest: Bool) {
        self.isShowingPlayerHandPositionRequest = isShowingRequest
    }

    func setPlayerHandPositionRequestArgs(_ args: PlayerHandPositionRequestArgs) {
        self.playerHandPositionRequestArgs = args
    }

    func toggleCardTypeRequest(to isShowingRequest: Bool) {
        self.isShowingCardTypeRequest = isShowingRequest
    }

    func setCardTypeRequestArgs(_ args: CardTypeRequestArgs) {
        self.cardTypeRequestArgs = args
    }

    func advanceToNextPlayer() {
        guard let nextPlayer = getNextPlayer() else {
            return
        }

        onAdvanceNextPlayer()
        players.setCurrentPlayer(nextPlayer)
    }
}
