//
//  AddCardToPlayerAction.swift
//  CardBox
//
//  Created by Stuart Long on 14/3/22.
//

struct AddCardToPlayerAction: Action {
    let player: Player
    let card: Card

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        gameRunner.executeGameEvents([
            AddCardToPlayerEvent(card: card, player: player)
        ])
    }
}
