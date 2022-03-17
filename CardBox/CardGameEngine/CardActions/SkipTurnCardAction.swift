//
//  SkipTurnCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct SkipTurnCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, card: Card, player: Player, target: GameplayTarget) {
        gameRunner.executeGameEvents([
            AdvanceNextPlayerEvent()
        ])
    }
}
