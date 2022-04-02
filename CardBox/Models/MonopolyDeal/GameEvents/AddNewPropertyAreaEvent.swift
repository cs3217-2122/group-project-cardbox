//
//  AddNewPropertyAreaEvent.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

struct AddNewPropertyAreaEvent: GameEvent {
    let propertyArea: MonopolyDealPlayerPropertyArea
    let cards: CardCollection

    func updateRunner(gameRunner: GameRunnerProtocol) {
        propertyArea.area.append(cards)
    }
}
