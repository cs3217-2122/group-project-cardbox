//
//  DiscardCardEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct PlayerDiscardCardEvent: GameEvent {
    let player: Player
    let cardToDiscard: Card

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.removeCard(cardToDiscard)
    }
}
