//
//  PlayerView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct PlayerView: View {
    var playerViewModel: PlayerViewModel
    @EnvironmentObject private var gameRunnerViewModel: GameRunner
    @Binding var error: Bool

    var body: some View {
        VStack {
            Text(playerViewModel.player.name)
            PlayerHandView(playerViewModel: playerViewModel,
                           playerHandViewModel: PlayerHandViewModel(hand: playerViewModel.player.hand),
                           error: $error)
        }
    }
}
