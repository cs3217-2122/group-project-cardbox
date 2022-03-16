//
//  PlayerView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct PlayerView: View {
    let playerViewModel: PlayerViewModel
    @ObservedObject var gameRunner: GameRunner

    init(player: Player, gameRunner: GameRunner) {
        self.playerViewModel = PlayerViewModel(player: player)
        self.gameRunner = gameRunner
    }

    var body: some View {
        VStack {
            Text(playerViewModel.player.name)
            PlayerHandView(hand: playerViewModel.player.hand)
        }
    }
}
