//
//  PlayerView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct PlayerView: View {
    private var playerViewModel: PlayerViewModel
    @EnvironmentObject private var gameRunnerViewModel: GameRunner

    init(playerViewModel: PlayerViewModel) {
        self.playerViewModel = playerViewModel
    }

    var body: some View {
        VStack {
            Text(playerViewModel.player.name)
            PlayerHandView(playerViewModel: playerViewModel, hand: playerViewModel.player.hand)
        }
    }
}
