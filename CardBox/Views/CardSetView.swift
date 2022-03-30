//
//  CardSetView.swift
//  CardBox
//
//  Created by Bernard Wan on 28/3/22.
//

import SwiftUI

struct CardSetView: View {
    let deckViewModel: DeckViewModel
    var isFaceUp: Bool
    let overlapAmount: Int
    let isVertical: Bool

    var cards: some View {
        ForEach(deckViewModel.getCards()) { card in
            // TODO: might need to pull isSelected from view model
            let cardViewModel = CardViewModel(card: card, isFaceUp: isFaceUp, isSelected: false)
            CardView(cardViewModel: cardViewModel)
        }
    }

    var body: some View {
        if isVertical {
            VStack(spacing: CGFloat(overlapAmount)) {
                cards
            }
        } else {
            HStack(spacing: CGFloat(overlapAmount)) {
                cards
            }
        }
    }
}
