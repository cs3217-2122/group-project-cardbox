//
//  ConditionalCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct ConditionalCardAction: CardAction {
    let condition: (GameRunnerReadOnly, Player, GameplayTarget) -> Bool
    let isTrueCardActions: [CardAction]
    let isFalseCardActions: [CardAction]?

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        let player = args.player
        let target = args.target

        let isConditionTrue = condition(gameRunner, player, target)

        if isConditionTrue {
            for isTrueCardAction in isTrueCardActions {
                isTrueCardAction.executeGameEvents(gameRunner: gameRunner, args: args)
            }
        } else {
            guard let isFalseCardActions = isFalseCardActions else {
                return
            }

            for isFalseCardAction in isFalseCardActions {
                isFalseCardAction.executeGameEvents(gameRunner: gameRunner, args: args)
            }
        }
    }
}
