//
//  CardView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct CardView: View {
    let viewModel: CardViewModel

    init(card: Card, player: Player, gameRunner: GameRunnerReadOnly) {
        self.viewModel = CardViewModel(card: card, player: player, gameRunner: gameRunner)
    }

    var body: some View {
        Text(viewModel.card.name)
            .onTapGesture {
                viewModel.playCard()
            }
    }
}
