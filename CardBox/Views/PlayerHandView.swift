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
    
    var body: some View {
        HStack(spacing: -100) {
            ForEach(viewModel.getCards()) { card in
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
