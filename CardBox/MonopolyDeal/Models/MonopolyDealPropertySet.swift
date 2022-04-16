//
//  MonopolyDealPropertySet.swift
//  CardBox
//
//  Created by Bernard Wan on 17/4/22.
//

class MonopolyDealPropertySet: MonopolyDealCardCollection {
    override func canAdd(_ card: Card) -> Bool {
        card is PropertyCard
    }
}
