//
//  NonCurrentPlayerView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct NonBottomPlayerView<PlayerView: View, CentreView: View>: View {
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @Binding var error: Bool
    var bottomPlayerViewModel: PlayerViewModel
    @Binding var selectedPlayerViewModel: PlayerViewModel?
    @ViewBuilder let playerArea: (Player) -> PlayerView
    @ViewBuilder let center: () -> CentreView

    var body: some View {
        VStack {
            if let player3 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(2) {
                playerArea(player3)
                    .rotationEffect(.degrees(-180))

            }
            Spacer()
            middlePart
            if bottomPlayerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                GameActionsView(error: $error,
                                currentPlayerViewModel: bottomPlayerViewModel,
                                selectedPlayerViewModel: $selectedPlayerViewModel)
            }
        }
    }

    @ViewBuilder
    var leftPlayer: some View {
        if let player4 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(3) {
            playerArea(player4)
                .rotationEffect(.degrees(90))
        } else {
            EmptyView()
        }
    }

    var middlePart: some View {
        HStack {
            leftPlayer
            Spacer()
            decks
            Spacer()
            if let player2 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(1) {
                playerArea(player2)
                    .rotationEffect(.degrees(-90))
            }
        }
    }
    var decks: some View {
        HStack {
            center()
        }

    }
}

struct NonCurrentPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
