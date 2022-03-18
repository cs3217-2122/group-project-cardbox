//
//  IsCurrentPlayerPlayCondition.swift
//  CardBox
//
//  Created by mactest on 17/03/2022.
//

struct IsCurrentPlayerPlayCondition: PlayerPlayCondition {
    func evaluate(gameRunner: GameRunnerReadOnly, args: PlayerPlayConditionArgs) -> Bool {
        gameRunner.players.currentPlayer === args.player
    }
}
