//
//  PlayerHandViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

class PlayerHandViewModel: ObservableObject {
    var hand: CardCollection

    init(hand: CardCollection) {
        self.hand = hand
    }

    var handSize: Int {
        hand.count
    }

    func getCards() -> [Card] {
        hand.getCards()
    }
}
