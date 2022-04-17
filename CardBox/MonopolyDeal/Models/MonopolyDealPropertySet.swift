//
//  MonopolyDealPropertySet.swift
//  CardBox
//
//  Created by Bernard Wan on 17/4/22.
//

class MonopolyDealPropertySet: MonopolyDealCardCollection {
    var setColor: PropertyColor

    var isFullSet: Bool {
        cards.count == setColor.setSize
    }

    init(cards: [Card], setColour: PropertyColor) {
        self.setColor = setColour
        super.init(cards: cards)
    }

    private enum CodingKeys: String, CodingKey {
        case setColor
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.setColor = try container.decode(PropertyColor.self, forKey: .setColor)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(setColor, forKey: .setColor)
    }

    override func canAdd(_ card: Card) -> Bool {
        if let card = card as? PropertyCard {
            return card.colors.contains(setColor)
        } else {
            return false
        }
    }
}
