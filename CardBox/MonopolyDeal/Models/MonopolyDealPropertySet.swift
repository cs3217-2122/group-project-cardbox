//
//  MonopolyDealPropertySet.swift
//  CardBox
//
//  Created by Bernard Wan on 17/4/22.
//

class MonopolyDealPropertySet: MonopolyDealCardCollection {
    var setColor: PropertyColor

    init(cards: [Card], setColour: PropertyColor) {
        self.setColor = setColour
        super.init(cards: cards)
    }

    private enum CodingKeys: String, CodingKey {
        case setColor
    }

    // TODO: Implement
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.setColor = try container.decode(PropertyColor.self, forKey: .setColor)
        try super.init(from: decoder)
    }

    override func canAdd(_ card: Card) -> Bool {
        if let card = card as? PropertyCard {
            return card.colors.contains(setColor)
        } else {
            return false
        }
    }
}
