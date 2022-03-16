//
//  DisplayCardsEvent.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct DisplayCardsEvent: GameEvent {
    let cards: [Card]

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        print(cards)
    }
}
