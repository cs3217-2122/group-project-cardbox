//
//  AddCardToDeckAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct AddCardToDeckAction: Action {
    let card: Card

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        gameRunner.executeGameEvents([
            AddCardToDeckEvent(card: card)
        ])
    }
}
