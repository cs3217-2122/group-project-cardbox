//
//  GameRunner.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

import SwiftUI

class GameRunner: GameRunnerReadOnly, GameRunnerInitOnly, GameRunnerUpdateOnly, ObservableObject {
    @Published internal var deck: CardCollection
    @Published internal var players: PlayerCollection
    @Published internal var gameplayArea: CardCollection
    @Published internal var state: GameState
    @Published internal var cardPreview: Card?
    @Published internal var cardsPeeking: [Card]

    // Exploding kitten specific variables
    @Published internal var isShowingDeckPositionRequest = false
    internal var deckPositionRequestArgs: DeckPositionRequestArgs?

    private var onSetupActions: [Action]
    private var onStartTurnActions: [Action]
    private var onEndTurnActions: [Action]

    init() {
        self.deck = CardCollection()
        self.onSetupActions = []
        self.onStartTurnActions = []
        self.onEndTurnActions = []
        self.gameplayArea = CardCollection()
        self.players = PlayerCollection()
        self.state = .initialize
        self.cardsPeeking = []
    }

    func addSetupAction(_ action: Action) {
        self.onSetupActions.append(action)
    }

    func addStartTurnAction(_ action: Action) {
        self.onStartTurnActions.append(action)
    }

    func addEndTurnAction(_ action: Action) {
        self.onEndTurnActions.append(action)
    }

    func setup() {
        self.onSetupActions.forEach { action in
            action.executeGameEvents(gameRunner: self)
        }
    }

    func onStartTurn() {
        self.onStartTurnActions.forEach { action in
            action.executeGameEvents(gameRunner: self)
        }
    }

    func onEndTurn() {
        self.onEndTurnActions.forEach { action in
            action.executeGameEvents(gameRunner: self)
        }
    }

    func executeGameEvents(_ gameEvents: [GameEvent]) {
        gameEvents.forEach { gameEvent in
            print(gameEvent)
            gameEvent.updateRunner(gameRunner: self)
        }
        notifyChanges()
    }

    func setGameState(gameState: GameState) {
        self.state = gameState
    }

    func notifyChanges() {
        objectWillChange.send()
    }

    func endPlayerTurn() {
        ActionDispatcher.runAction(EndTurnAction(), on: self)
    }

    func setCardsPeeking(cards: [Card]) {
        self.cardsPeeking = cards
    }

    func showDeckPositionRequest() {
        self.isShowingDeckPositionRequest = true
    }

    func hideDeckPositionRequest() {
        self.isShowingDeckPositionRequest = false
    }

    func setDeckPositionRequestArgs(_ args: DeckPositionRequestArgs) {
        self.deckPositionRequestArgs = args
    }

    func dispatchDeckPositionResponse(offsetFromTop: Int) {
        guard let args = deckPositionRequestArgs else {
            return
        }

        ActionDispatcher.runAction(
            DeckPositionResponseAction(card: args.card, player: args.player, offsetFromTop: offsetFromTop),
            on: self
        )
    }
}
