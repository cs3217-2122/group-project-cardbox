//
//  GameRunnerReadOnly.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

protocol GameRunnerReadOnly {
    var deck: CardCollection { get }
    var state: GameState { get }
    var players: PlayerCollection { get }
    var gameplayArea: CardCollection { get }

    var onSetupActions: [Action] { get }
    var onStartTurnActions: [Action] { get }
    var onEndTurnActions: [Action] { get }

    func executeGameEvents(_ gameEvents: [GameEvent])
}
