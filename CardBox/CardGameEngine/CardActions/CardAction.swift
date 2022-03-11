//
//  CardAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

protocol CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, player: Player, target: GameplayTarget)
}
