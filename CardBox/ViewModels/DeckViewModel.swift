//
//  DeckViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 16/3/22.
//

import Foundation

class DeckViewModel: ObservableObject {
    var deck: CardCollection

    init(deck: CardCollection) {
        self.deck = deck
    }

    func getCards() -> [Card] {
        deck.getCards()
    }

    func getTopCard() -> Card? {
        deck.getFirstCard()
    }
}
