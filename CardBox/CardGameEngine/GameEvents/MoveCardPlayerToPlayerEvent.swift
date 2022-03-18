//
//  MoveCardPlayerToPlayerEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/3/22.
//

struct MoveCardPlayerToPlayerEvent: GameEvent {
    let card: Card
    let fromPlayer: Player
    let toPlayer: Player

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        fromPlayer.removeCard(card)
        toPlayer.addCard(card)
    }
}
