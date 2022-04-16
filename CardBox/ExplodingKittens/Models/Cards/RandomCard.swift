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

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
