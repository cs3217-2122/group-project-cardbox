//
//  MovePropertyAreaEvent.swift
//  CardBox
//
//  Created by user213938 on 4/6/22.
//

struct MovePropertyAreaEvent: GameEvent {
    let cardSet: MonopolyDealPropertySet
    let fromArea: MonopolyDealPlayerPropertyArea
    let toArea: MonopolyDealPlayerPropertyArea

    func updateRunner(gameRunner: GameRunnerProtocol) {
        fromArea.removeCardCollection(cardSet)
        toArea.addCardCollection(cardSet)
    }
}
