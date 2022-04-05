//
//  RandomCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//
import Foundation

class RandomCard: ExplodingKittensCard {
    init(name: String, type: ExplodingKittensCardType) {
        super.init(
            name: name,
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: type
        )
    }

    init(id: UUID, name: String, type: ExplodingKittensCardType) {
        super.init(
            id: id,
            name: name,
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: type
        )
    }
}
