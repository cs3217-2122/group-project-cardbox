//
//  MoveCardPlayerToDeckEvent.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct MoveCardPlayerToDeckEvent: GameEvent {
    let card: Card
    let player: Player
    let offsetFromTop: Int

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.removeCard(card)
        gameRunner.deck.addCard(card, offsetFromTop: offsetFromTop)
    }
}
