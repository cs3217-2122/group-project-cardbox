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
        guard let index = propertyArea.area.firstIndex(where: { $0 === cards }) else {
            return
        }
        propertyArea.area.remove(at: index)
    }
}
