//
//  PlayerHandView.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct PlayerHandView: View {
    let viewModel: PlayerHandViewModel

    init(hand: CardCollection) {
        self.viewModel = PlayerHandViewModel(hand: hand)
    }

    var spacing: Double {
        let size = viewModel.getSize()
        // availableSpace - size * cardWidth / size
        // TODO: figure out spacing
        return Double((400 - size * 150) / size)
    }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(viewModel.getCards()) { card in
                CardView(cardViewModel: CardViewModel(card: card, isFaceUp: true))
            }
        }
    }
}

struct PlayerHandView_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
