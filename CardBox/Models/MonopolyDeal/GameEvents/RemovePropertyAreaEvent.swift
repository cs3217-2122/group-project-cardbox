//
//  RemovePropertyAreaEvent.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

struct RemovePropertyAreaEvent: GameEvent {
    let propertyArea: MonopolyDealPlayerPropertyArea
    let cards: CardCollection

    func updateRunner(gameRunner: GameRunnerProtocol) {
        propertyArea.removeCardCollection(cards)
    }
}
