//
//  EndTurnWithoutActionsCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct EndTurnWithoutActionsCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, player: Player, target: GameplayTarget) {
        gameRunner.executeGameEvents([
            EndTurnEvent()
        ])
    }
}
