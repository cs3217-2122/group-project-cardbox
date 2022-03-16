//
//  PlayerHandView.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct PlayerHandView: View {
    let playerHandViewModel: PlayerHandViewModel
    
    init(hand: CardCollection) {
        self.playerHandViewModel = PlayerHandViewModel(hand: hand)
    }
    
    var spacing: Double {
        let size = playerHandViewModel.getSize()
        // availableSpace - size * cardWidth / size
        // TODO: figure out spacing
        return Double((400 - size * 150) / size)
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(playerHandViewModel.getCards()) { card in
                CardView(card: card)
            }
        }
    }
}

struct PlayerHandView_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
