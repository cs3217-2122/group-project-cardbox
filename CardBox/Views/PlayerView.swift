//
//  PlayerView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct PlayerView: View {
    let viewModel: PlayerViewModel
    @ObservedObject var gameRunner: GameRunner

    init(player: Player, gameRunner: GameRunner) {
        self.viewModel = PlayerViewModel(player: player, gameRunner: gameRunner)
        self.gameRunner = gameRunner
    }

    var playerDescription: String {
        viewModel.player.name + (viewModel.player.isOutOfGame ? " (Dead)" : "")
    }

    var body: some View {
        VStack {
            Text(playerDescription)
            ForEach(viewModel.player.hand.getCards()) { card in
                CardView(card: card, player: viewModel.player, gameRunner: viewModel.gameRunner)
            }
        }
    }
}
