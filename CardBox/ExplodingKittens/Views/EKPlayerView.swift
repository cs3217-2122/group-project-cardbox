//
//  PlayerView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct EKPlayerView: View {
    var playerViewModel: PlayerViewModel
    var currentPlayerViewModel: PlayerViewModel
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: ExplodingKittensGameRunnerProtocol? {
        gameRunnerDelegate.runner as? ExplodingKittensGameRunnerProtocol
    }

    @Binding var error: Bool
    @Binding var selectedPlayerViewModel: PlayerViewModel?

    var playerText: String {
        var playerName = playerViewModel.player.name
        if playerViewModel.player.isOutOfGame {
            playerName += "(Dead)"
        }
        if playerViewModel.player === gameRunnerViewModel?.players.currentPlayer {
            playerName = "Current Player: " + playerName
        }
        return playerName
    }

    var body: some View {
        VStack {
            Button {
                guard let ekRunner = self.gameRunnerViewModel else {
                    return
                }
                if !playerViewModel.isCurrentPlayer(gameRunner: ekRunner) {
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
            PlayerHandView(playerViewModel: playerViewModel, bottomPlayerViewModel: currentPlayerViewModel,
                           playerHandViewModel: PlayerHandViewModel(hand: playerViewModel.hand),
                           error: $error)
                .opacity(playerViewModel.isDead() ? 0.5 : 1)
        }
    }
}