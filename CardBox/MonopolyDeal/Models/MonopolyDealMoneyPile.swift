//
//  MonopolyDealMoneyPile.swift
//  CardBox
//
//  Created by Bernard Wan on 17/4/22.
//

class MonopolyDealMoneyPile: MonopolyDealCardCollection {
    override func canAdd(_ card: Card) -> Bool {
        card is MoneyCard || card is ActionCard
    }
}
