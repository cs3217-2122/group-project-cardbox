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
        self.viewModel = PlayerViewModel(player: player)
        self.gameRunner = gameRunner
    }

    var body: some View {
        VStack {
            Text(viewModel.player.name)
            PlayerHandView(hand: viewModel.player.hand)
        }
    }
}
