//
//  AddCardTo.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct AddCardToPlayerEvent: GameEvent {
    let card: Card
    let player: Player

    func updateRunner(gameRunner: GameRunner) {
        player.addCard(card)
    }
}
