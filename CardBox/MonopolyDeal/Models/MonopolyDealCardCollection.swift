//
//  MonopolyDealCardCollection.swift
//  CardBox
//
//  Created by Stuart Long on 15/4/22.
//

class MonopolyDealCardCollection: CardCollection {
    enum ObjectTypeKey: CodingKey {
        case type
    }

    init() {
        super.init(cards: [])
    }

    // TODO: simplify this
    required init(from decoder: Decoder) throws {
        try super.init(
            from: decoder,
            mapFunc: { decoder, type in
                guard let metatype = type.metatype else {
                    return nil
                }
                return try? metatype.init(from: decoder)
            },
            cardType: MonopolyDealCardType.self
        )
    }

}
