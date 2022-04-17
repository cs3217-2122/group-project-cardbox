//
//  ExplodingKittensCardCollection.swift
//  CardBox
//
//  Created by user213938 on 4/13/22.
//

class ExplodingKittensCardCollection: CardCollection {
    enum ObjectTypeKey: CodingKey {
        case type
    }

    init() {
        super.init(cards: [])
    }

    required init(from decoder: Decoder) throws {
        try super.init(
            from: decoder,
            mapFunc: { decoder, type in
                guard let metatype = type.metatype else {
                    return nil
                }
                return try? metatype.init(from: decoder)
            },
            cardType: ExplodingKittensCardType.self
        )
    }

    override func encode(to encoder: Encoder) {
        super.encode(
            to: encoder,
            mapFunc: { card in
                guard let ekCard = card as? ExplodingKittensCard else {
                    return nil
                }
                return ExplodingKittensCardFactory.getCardTypeFromObject(card: ekCard)
            },
            cardType: ExplodingKittensCardType.self
        )
    }
}
