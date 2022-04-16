//
//  RandomCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

import Foundation

enum RandomCardType: String, Codable {
    case random1 = "random-1"
    case random2 = "random-2"
    case random3 = "random-3"
}

class RandomCard: ExplodingKittensCard {
    let randomCardType: RandomCardType

    init(name: String, cardType: RandomCardType) {
        self.randomCardType = cardType
        super.init(
            name: name,
            typeOfTargettedCard: .targetSinglePlayerCard
        )
    }

    init(id: UUID, name: String, cardType: RandomCardType) {
        self.randomCardType = cardType
        super.init(
            id: id,
            name: name,
            typeOfTargettedCard: .targetSinglePlayerCard
        )
    }

    private enum CodingKeys: String, CodingKey {
        case randomCardType
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.randomCardType = try container.decode(RandomCardType.self, forKey: .randomCardType)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.randomCardType, forKey: .randomCardType)
        try super.encode(to: encoder)
    }
}
