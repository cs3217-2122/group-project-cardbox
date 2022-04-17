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

    override init(cards: [Card]) {
        super.init(cards: cards)
    }

    override init(cards: [Card], isFaceUp: Bool) {
        super.init(cards: cards, isFaceUp: isFaceUp)
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
            cardType: MonopolyDealCardType.self
        )
    }

    override func encode(to encoder: Encoder) {
        super.encode(
            to: encoder,
            mapFunc: { card in
                guard let mdCard = card as? MonopolyDealCard else {
                    return nil
                }
                return MonopolyDealCardFactory.getCardTypeFromObject(card: mdCard)
            },
            cardType: MonopolyDealCardType.self
        )
    }
}
