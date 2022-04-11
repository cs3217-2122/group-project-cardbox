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
            typeOfTargettedCard: .noTargetCard,
            type: .defuse
        )
    }

    init(id: UUID) {
        super.init(
            id: id,
            name: "Defuse",
            typeOfTargettedCard: .noTargetCard,
            type: .defuse
        )
    }
}
