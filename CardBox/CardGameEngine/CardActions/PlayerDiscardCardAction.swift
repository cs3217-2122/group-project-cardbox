//
//  PlayerDiscardCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct PlayerDiscardCardAction: CardAction {
    let cardToDiscard: Card

    func executeGameEvents(gameRunner: GameRunnerReadOnly, player: Player, target: GameplayTarget) {
        gameRunner.executeGameEvents([PlayerDiscardCardEvent(player: player, cardToDiscard: cardToDiscard)])
    }
}
