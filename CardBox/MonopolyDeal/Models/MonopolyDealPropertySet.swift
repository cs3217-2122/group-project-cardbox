//
//  MonopolyDealPropertySet.swift
//  CardBox
//
//  Created by Bernard Wan on 17/4/22.
//

class MonopolyDealPropertySet: MonopolyDealCardCollection {
    var setColour: PropertyColor

    init(setColour: PropertyColor) {
        self.setColour = setColour
        super.init()
    }

    // TODO: Implement
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    override func canAdd(_ card: Card) -> Bool {
        if let card = card as? PropertyCard {
            return card.colors.contains(setColour)
        } else {
            return false
        }
    }
}
