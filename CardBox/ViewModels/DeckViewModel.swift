//
//  DeckViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 16/3/22.
//
import SwiftUI

class DeckViewModel: ObservableObject {
    var deck: CardCollection
    var isPlayDeck: Bool

    init(deck: CardCollection, isPlayDeck: Bool) {
        self.deck = deck
        self.isPlayDeck = isPlayDeck
    }

    func getCards() -> [Card] {
        deck.getCards()
    }

    var topCard: Card? {
        deck.topCard
    }
}

extension DeckViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: ["cardbox.card"]) else {
            return false
        }

        // check playable?
        
        // for card in info.itemProviders(for: ["cardbox.card"]) {
        //    card.loadObject(ofClass: Card.self) { _, _ in

        //    }
        //    deck.addCard(card)
        // }
        return true

    }

}
