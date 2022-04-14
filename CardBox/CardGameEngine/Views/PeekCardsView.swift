//
//  PeekCardsView.swift
//  CardBox
//
//  Created by Bernard Wan on 19/3/22.
//

import SwiftUI

struct PeekCardsView: View {
    var cards: [Card]

    var body: some View {
        HStack {
            ForEach(cards) { card in
                CardView(card: card, isFaceUp: true, isSelected: false)
            }
        }
    }
}
