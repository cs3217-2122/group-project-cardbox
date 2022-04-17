//
//  NonPlayerView.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

struct NonPlayerView<PlayerView: View, CentreView: View>: View {
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @Binding var error: Bool
    let localPlayerIndex: Int
    var bottomPlayerViewModel: PlayerViewModel
    @Binding var selectedPlayerViewModel: PlayerViewModel?
    @Binding var selectedCardSetViewModel: CardSetViewModel?
    @ViewBuilder let playerArea: (Player, Double) -> PlayerView
    @ViewBuilder let center: () -> CentreView

    init(bottomPlayer: Player, selectedPlayerViewModel: Binding<PlayerViewModel?>,
         selectedCardSetViewModel: Binding<CardSetViewModel?>,
         localPlayerIndex: Int,
         error: Binding<Bool>,
         playerArea: @escaping (Player, Double) -> PlayerView,
         center: @escaping () -> CentreView) {
        bottomPlayerViewModel = PlayerViewModel(player: bottomPlayer, hand: CardCollection())
        self.localPlayerIndex = localPlayerIndex
        self._selectedPlayerViewModel = selectedPlayerViewModel
        self._selectedCardSetViewModel = selectedCardSetViewModel
        self._error = error
        self.playerArea = playerArea
        self.center = center
    }

    var body: some View {
        VStack {
            if let topPlayer = gameRunnerViewModel.gameState.players.getPlayerByIndexAfterGiven(
                start: localPlayerIndex, increment: 2) {
                playerArea(topPlayer, -180)
            }
            Spacer()
            middlePart
            if bottomPlayerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                GameActionsView(error: $error,
                                currentPlayerViewModel: bottomPlayerViewModel,
                                selectedPlayerViewModel: $selectedPlayerViewModel,
                                selectedCardSetViewModel: $selectedCardSetViewModel)
            }
        }
    }

    var middlePart: some View {
        HStack {
            leftPlayer
            Spacer()
            center()
            Spacer()
            rightPlayer
        }
    }

    @ViewBuilder
    var leftPlayer: some View {
        if let leftPlayer = gameRunnerViewModel.gameState.players.getPlayerByIndexAfterGiven(
            start: localPlayerIndex, increment: 3) {
            playerArea(leftPlayer, 90)
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    var rightPlayer: some View {
        if let rightPlayer = gameRunnerViewModel.gameState.players.getPlayerByIndexAfterGiven(
            start: localPlayerIndex, increment: 1) {
            playerArea(rightPlayer, -90)
        } else {
            EmptyView()
        }
    }
}
