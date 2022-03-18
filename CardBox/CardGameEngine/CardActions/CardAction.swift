//
//  CardAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct CardActionArgs {
    let card: Card?
    let player: Player
    let target: GameplayTarget
}

protocol CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs)
}
