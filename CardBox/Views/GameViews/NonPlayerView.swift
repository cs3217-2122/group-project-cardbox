//
//  NonPlayerView.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

struct NonPlayerView: View {
    @EnvironmentObject private var gameRunnerViewModel: ExplodingKittensGameRunner
    @Binding var error: Bool
    let localPlayerIndex: Int
    var currentPlayerViewModel: PlayerViewModel
    @Binding var selectedPlayerViewModel: PlayerViewModel?

    var body: some View {
        VStack {
            if let topPlayer = gameRunnerViewModel.players.getPlayerByIndexAfterGiven(
                start: localPlayerIndex, increment: 2) {
                PlayerView(
                    playerViewModel: PlayerViewModel(
                        player: topPlayer,
                        hand: gameRunnerViewModel.getHandByPlayer(topPlayer) ?? CardCollection()
                    ),
                    currentPlayerViewModel: currentPlayerViewModel,
                    error: $error,
                    selectedPlayerViewModel: $selectedPlayerViewModel
                )
                .rotationEffect(.degrees(-180))

            }
            Spacer()
            middlePart
            GameActionsView(error: $error,
                            currentPlayerViewModel: currentPlayerViewModel,
                            selectedPlayerViewModel: $selectedPlayerViewModel)
        }
    }

    var middlePart: some View {
        HStack {
            leftPlayer
            Spacer()
            DeckView(deckViewModel:
                        DeckViewModel(deck: gameRunnerViewModel.deck,
                                      isPlayDeck: false, gameRunner: gameRunnerViewModel),
                     isFaceUp: false)
            DeckView(deckViewModel:
                        DeckViewModel(deck: gameRunnerViewModel.gameplayArea,
                                      isPlayDeck: true, gameRunner: gameRunnerViewModel),
                     isFaceUp: true)
            Spacer()
            rightPlayer
        }
    }

    var leftPlayer: some View {
        if let leftPlayer = gameRunnerViewModel.players.getPlayerByIndexAfterGiven(
            start: localPlayerIndex, increment: 3) {
            return AnyView(
                PlayerView(
                    playerViewModel: PlayerViewModel(
                        player: leftPlayer,
                        hand: gameRunnerViewModel.getHandByPlayer(leftPlayer) ?? CardCollection()
                    ),
                    currentPlayerViewModel: currentPlayerViewModel,
                    error: $error,
                    selectedPlayerViewModel: $selectedPlayerViewModel
                )
                .rotationEffect(.degrees(90))
            )
        } else {
            return AnyView(EmptyView())
        }
    }

    var rightPlayer: some View {
        if let rightPlayer = gameRunnerViewModel.players.getPlayerByIndexAfterGiven(
            start: localPlayerIndex, increment: 1) {
            return AnyView(
                PlayerView(
                    playerViewModel: PlayerViewModel(
                        player: rightPlayer,
                        hand: gameRunnerViewModel.getHandByPlayer(rightPlayer) ?? CardCollection()
                    ),
                    currentPlayerViewModel: currentPlayerViewModel,
                    error: $error,
                    selectedPlayerViewModel: $selectedPlayerViewModel
                )
                .rotationEffect(.degrees(-90))
            )
        } else {
            return AnyView(EmptyView())
        }
    }
}
