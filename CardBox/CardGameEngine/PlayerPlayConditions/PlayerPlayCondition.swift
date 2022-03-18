//
//  PlayerPlayCondition.swift
//  CardBox
//
//  Created by mactest on 17/03/2022.
//

struct PlayerPlayConditionArgs {
    let cards: [Card]
    let player: Player
}

protocol PlayerPlayCondition {
    func evaluate(gameRunner: GameRunnerReadOnly, args: PlayerPlayConditionArgs) -> Bool
}
