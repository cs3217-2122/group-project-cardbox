//
//  DefuseCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//
import Foundation

class DefuseCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Defuse",
            typeOfTargettedCard: .noTargetCard
        )
    }

    init(id: UUID) {
        super.init(
            id: id,
            name: "Defuse",
            typeOfTargettedCard: .noTargetCard
        )
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
