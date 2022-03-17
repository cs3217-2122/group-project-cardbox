//
//  CardAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

protocol CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, card: Card, player: Player, target: GameplayTarget)
}
