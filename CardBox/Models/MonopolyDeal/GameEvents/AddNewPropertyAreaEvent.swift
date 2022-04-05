//
//  AddNewPropertyAreaEvent.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

struct AddNewPropertyAreaEvent: GameEvent {
    let propertyArea: MonopolyDealPlayerPropertyArea
    let cards: CardCollection
    let fromHand: CardCollection

    func updateRunner(gameRunner: GameRunnerProtocol) {
        propertyArea.area.append(cards)
        cards.getCards().forEach { card in
            fromHand.removeCard(card)
        }
    }
}
