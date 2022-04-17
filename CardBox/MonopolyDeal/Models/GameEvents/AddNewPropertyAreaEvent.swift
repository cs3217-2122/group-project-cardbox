//
//  AddNewPropertyAreaEvent.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

struct AddNewPropertyAreaEvent: GameEvent {
    let propertyArea: MonopolyDealPlayerPropertyArea
    let card: PropertyCard
    let fromHand: CardCollection

    func updateRunner(gameRunner: GameRunnerProtocol) {
        propertyArea.addPropertyCard(card)
    }
}
