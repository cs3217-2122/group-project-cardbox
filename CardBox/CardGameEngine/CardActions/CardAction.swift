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
    func run(gameRunner: GameRunnerReadOnly, args: CardActionArgs)
}
