//
//  HouseCard.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

class HouseCard: MonopolyDealCard {
    init() {
        super.init(
            name: "House",
            typeOfTargettedCard: .targetSingleDeckCard,
            type: .house
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        if case .deck(let collection) = target {

        }
    }
}
