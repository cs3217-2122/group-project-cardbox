//
//  RandomCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

class RandomCard: ExplodingKittensCard {
    init(name: String, type: ExplodingKittensCardType) {
        super.init(
            name: name,
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: type
        )
    }
}
