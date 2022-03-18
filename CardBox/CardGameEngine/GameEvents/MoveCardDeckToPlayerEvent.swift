//
//  MoveCardPlayerToDeckEvent.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct MoveCardDeckToPlayerEvent: GameEvent {
    let card: Card
    let player: Player

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        player.addCard(card)
        gameRunner.deck.removeCard(card)
    }
}
