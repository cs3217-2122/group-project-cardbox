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

    func executeGameEvents(_ gameEvents: [GameEvent])
}
