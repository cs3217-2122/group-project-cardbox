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

    func executeGameEvents(gameRunner: GameRunnerReadOnly, player: Player, target: GameplayTarget) {
        let isConditionTrue = condition(gameRunner, player, target)

        if isConditionTrue {
            for isTrueCardAction in isTrueCardActions {
                isTrueCardAction.executeGameEvents(gameRunner: gameRunner, player: player, target: target)
            }
        } else {
            guard let isFalseCardActions = isFalseCardActions else {
                return
            }

            for isFalseCardAction in isFalseCardActions {
                isFalseCardAction.executeGameEvents(gameRunner: gameRunner, player: player, target: target)
            }
        }
    }
}
