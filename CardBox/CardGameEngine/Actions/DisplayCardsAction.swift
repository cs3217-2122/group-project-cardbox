//
//  DisplayCardsAction.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct DisplayCardsAction: Action {
    let cards: [Card]

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        gameRunner.executeGameEvents([
            DisplayCardsEvent(cards: self.cards)
        ])
    }
}
