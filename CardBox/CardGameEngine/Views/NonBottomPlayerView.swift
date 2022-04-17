//
//  NonBottomPlayerView.swift
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
    @Binding var selectedCardSetViewModel: CardSetViewModel?
    @ViewBuilder let playerArea: (Player, Double) -> PlayerView
    @ViewBuilder let center: () -> CentreView

    init(bottomPlayer: Player, selectedPlayerViewModel: Binding<PlayerViewModel?>,
         selectedCardSetViewModel: Binding<CardSetViewModel?>,
         error: Binding<Bool>,
         playerArea: @escaping (Player, Double) -> PlayerView,
         center: @escaping () -> CentreView) {
        bottomPlayerViewModel = PlayerViewModel(player: bottomPlayer, hand: CardCollection())
        self._selectedPlayerViewModel = selectedPlayerViewModel
        self._selectedCardSetViewModel = selectedCardSetViewModel
        self._error = error
        self.playerArea = playerArea
        self.center = center
    }

    var body: some View {
        VStack {
            if let player3 = gameRunnerViewModel.gameState.players.getPlayerByIndexAfterCurrent(2) {
                playerArea(player3, -180)
            }
            Spacer()
            middlePart
                .frame(width: UIScreen.main.bounds.width, height: CGFloat(gameRunnerViewModel.cardHeight))
        }
    }

    @ViewBuilder
    var leftPlayer: some View {
        if let player4 = gameRunnerViewModel.gameState.players.getPlayerByIndexAfterCurrent(3) {
            playerArea(player4, 90)
        } else {
            EmptyView()
        }
    }

    var middlePart: some View {
        HStack {
            leftPlayer
            Spacer()
            decks
            if bottomPlayerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                GameActionsView(error: $error,
                                currentPlayerViewModel: bottomPlayerViewModel,
                                selectedPlayerViewModel: $selectedPlayerViewModel,
                                selectedCardSetViewModel: $selectedCardSetViewModel)
            }
            Spacer()
            if let player2 = gameRunnerViewModel.gameState.players.getPlayerByIndexAfterCurrent(1) {
                playerArea(player2, -90)
            }
        }
    }
    var decks: some View {
        HStack {
            center()
        }

    }
}
