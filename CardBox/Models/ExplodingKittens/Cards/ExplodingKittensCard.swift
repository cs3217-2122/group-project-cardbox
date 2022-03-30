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

    enum CodingKeys: String, CodingKey {
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(ExplodingKittensCardType.self, forKey: .type)
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
}
