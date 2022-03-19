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
    @Binding var selectedPlayerViewModel: PlayerViewModel?

    var body: some View {
        VStack {
            Button {
                if !playerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                    selectedPlayerViewModel = playerViewModel
                    print("Selected \(selectedPlayerViewModel?.player.name ?? "none")")
                }
            } label: {
                Text(playerViewModel.player.name)
                    .foregroundColor(selectedPlayerViewModel === playerViewModel ? Color.red : Color.blue)
            }
            PlayerHandView(playerViewModel: playerViewModel,
                           playerHandViewModel: PlayerHandViewModel(hand: playerViewModel.player.hand),
                           error: $error)
        }
    }
}
