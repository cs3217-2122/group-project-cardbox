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

    var playerText: String {
        if playerViewModel.isDead() {
            return playerViewModel.player.name + " (Dead)"
        }
        return playerViewModel.player.name
    }

    var body: some View {
        VStack {
            Button {
                if !playerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                    if !playerViewModel.isDead() {
                        selectedPlayerViewModel = playerViewModel
                    }
                }
            } label: {
                if let selectedPlayerViewModel = selectedPlayerViewModel {
                    Text(playerText)
                        .foregroundColor(selectedPlayerViewModel.player === playerViewModel.player
                                         ? Color.red : Color.blue)
                } else {
                    Text(playerText)
                }

            }
            PlayerHandView(playerViewModel: playerViewModel,
                           playerHandViewModel: PlayerHandViewModel(hand: playerViewModel.player.hand),
                           error: $error)
                .opacity(playerViewModel.isDead() ? 0.5 : 1)
        }
    }
}
