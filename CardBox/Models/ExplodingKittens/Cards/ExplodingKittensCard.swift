//
//  ExplodingKittensCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class ExplodingKittensCard: Card {
    let type: ExplodingKittensCardType

    init(
        name: String,
        typeOfTargettedCard: TypeOfTargettedCard,
        type: ExplodingKittensCardType,
        cardDescription: String = ""
    ) {
        self.type = type
        super.init(
            name: name,
            typeOfTargettedCard: typeOfTargettedCard,
            cardDescription: cardDescription
        )
    }
}
