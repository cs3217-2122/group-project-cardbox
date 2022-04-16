//
//  MonopolyDealMoneyPile.swift
//  CardBox
//
//  Created by Bernard Wan on 17/4/22.
//

class MonopolyDealMoneyPile: MonopolyDealCardCollection {
    override func canAdd(card: Card) -> Bool {
        if card is MoneyCard || card is ActionCard {
            return true
        } else {
            return false
        }
    }
}
