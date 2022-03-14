//
//  PlayerView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct PlayerView: View {
    let viewModel: PlayerViewModel

    init(player: Player) {
        self.viewModel = PlayerViewModel(player: player)
    }

    var body: some View {
        VStack {
            Text(viewModel.player.name)
            ForEach(viewModel.player.hand.getCards()) { card in
                CardView(card: card)
            }
        }
    }
}
