//
//  GameRunner.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

class GameRunner: GameRunnerReadOnly {
    internal var deck: CardCollection
    internal var players: PlayerCollection
    internal var gameplayArea: CardCollection
    internal var state: GameState

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

    func updateState(_ state: GameState) {
        // TODO: Need to change
        switch self.state {
        case .start:
            if state == .waitPlayCard {
                self.state = .waitPlayCard
            }
        case .waitPlayCard:
            if state == .start {
                onEndTurn()
                self.state = .start
                onStartTurn()
            }
        case .initialize:
            if state == .start {
                setup()
                self.state = .start
                onStartTurn()
            }
        }
    }

    func executeGameEvents(_ gameEvents: [GameEvent]) {
        // TODO: Need to change
        gameEvents.forEach { gameEvent in
            gameEvent.updateRunner(gameRunner: self)
        }
    }
}
