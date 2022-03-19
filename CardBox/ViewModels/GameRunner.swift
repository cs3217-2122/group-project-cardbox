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

    // Exploding kitten specific variables
    @Published internal var isShowingDeckPositionRequest = false
    @Published internal var isShowingPlayerHandPositionRequest = false
    @Published internal var isShowingCardRequest = false
    internal var deckPositionRequestArgs: DeckPositionRequestArgs?
    internal var playerHandPositionRequestArgs: PlayerHandPositionRequestArgs?
    internal var cardRequestArgs: CardRequestArgs?

    private var onSetupActions: [Action]
    private var onStartTurnActions: [Action]
    private var onEndTurnActions: [Action]
    private var nextPlayerGenerator: NextPlayerGenerator?

    init() {
        self.deck = CardCollection()
        self.onSetupActions = []
        self.onStartTurnActions = []
        self.onEndTurnActions = []
        self.gameplayArea = CardCollection()
        self.players = PlayerCollection()
        self.state = .initialize
        self.nextPlayerGenerator = nil
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

    func setNextPlayerGenerator(_ generator: NextPlayerGenerator) {
        self.nextPlayerGenerator = generator
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

    func toggleDeckPositionRequest(to isShowingRequest: Bool) {
        self.isShowingDeckPositionRequest = isShowingRequest
    }

    func setDeckPositionRequestArgs(_ args: DeckPositionRequestArgs) {
        self.deckPositionRequestArgs = args
    }

    func togglePlayerHandPositionRequest(to isShowingRequest: Bool) {
        self.isShowingPlayerHandPositionRequest = isShowingRequest
        print(isShowingPlayerHandPositionRequest)
    }

    func setPlayerHandPositionRequestArgs(_ args: PlayerHandPositionRequestArgs) {
        self.playerHandPositionRequestArgs = args
    }

    func toggleCardRequest(to isShowingRequest: Bool) {
        self.isShowingCardRequest = isShowingRequest
    }

    func setCardRequestArgs(_ args: CardRequestArgs) {
        self.cardRequestArgs = args
    }

    func advanceToNextPlayer() {
        guard let nextPlayer = nextPlayerGenerator?.getNextPlayer(gameRunner: self) else {
            return
        }

        players.setCurrentPlayer(nextPlayer)
    }

    // Exploding kitten specific related methods

    var getAllCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensUtils.getAllCardTypes()
    }

    func dispatchDeckPositionResponse(offsetFromTop: Int) {
        guard let args = deckPositionRequestArgs else {
            return
        }

        ActionDispatcher.runAction(
            DeckPositionResponseAction(card: args.card,
                                       player: args.player,
                                       offsetFromTop: offsetFromTop),
            on: self
        )
    }

    func dispatchPlayerHandPositionResponse(playerHandPosition: Int) {
        guard let args = playerHandPositionRequestArgs else {
            return
        }

        ActionDispatcher.runAction(
            PlayerHandPositionResponseAction(target: args.target,
                                             player: args.player,
                                             playerHandPosition: playerHandPosition),
            on: self
        )
    }

    func dispatchCardRequestResponse(type: String) {
        guard let args = cardRequestArgs else {
            return
        }

//        ActionDispatcher.runAction(
//            ,
//            on: self)
    }
}
