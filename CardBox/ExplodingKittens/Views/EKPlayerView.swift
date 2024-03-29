//
//  PlayerView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct EKPlayerView: View {
    var playerViewModel: PlayerViewModel
    var bottomPlayer: Player
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: ExplodingKittensGameRunnerProtocol? {
        gameRunnerDelegate.runner as? ExplodingKittensGameRunnerProtocol
    }
    var rotateBy = 0.0

    @Binding var error: Bool
    @Binding var selectedPlayerViewModel: PlayerViewModel?

    init(player: Player, hand: CardCollection, bottomPlayer: Player, rotateBy: Double,
         error: Binding<Bool>, selectedPlayerViewModel: Binding<PlayerViewModel?>) {
        playerViewModel = PlayerViewModel(player: player,
                                          hand: hand)
        self.bottomPlayer = bottomPlayer
        self.rotateBy = rotateBy
        self._error = error
        self._selectedPlayerViewModel = selectedPlayerViewModel
    }

    var frameWidth: CGFloat {
        if rotateBy == 90 || rotateBy == -90 {
            return CGFloat((gameRunnerViewModel?.cardHeight ?? 250) + 30)
        } else {
            return CGFloat(PlayerHandView.handWidth)
        }
    }

    var frameHeight: CGFloat {
        if rotateBy == 90 || rotateBy == -90 {
            return CGFloat(PlayerHandView.handWidth)
        } else {
            return CGFloat((gameRunnerViewModel?.cardHeight ?? 250) + 30)
        }
    }

    var playerText: String {
        var playerName = playerViewModel.player.name
        if playerViewModel.player.isOutOfGame {
            playerName += "(Dead)"
        }
        if playerViewModel.player === gameRunnerViewModel?.gameState.players.currentPlayer {
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
            PlayerHandView(player: playerViewModel.player,
                           hand: playerViewModel.hand,
                           bottomPlayer: bottomPlayer,
                           error: $error)
                .opacity(playerViewModel.isDead() ? 0.5 : 1)
        }
        .rotationEffect(Angle(degrees: rotateBy))
        .fixedSize()
        .frame(width: frameWidth, height: frameHeight)
    }
}
