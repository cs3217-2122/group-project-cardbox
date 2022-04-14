//
//  MonopolyDealOfflineView.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

struct MonopolyDealOfflineView: View {
    @StateObject var gameRunnerViewModel = MonopolyDealGameRunner()
    @State var error = true
    @State var selectedPlayerViewModel: PlayerViewModel?
    @State var selectedCardSetViewModel: CardSetViewModel?
    @State var cardPreview: Card?

    @ViewBuilder
    var centerArea: some View {
        HStack {
            DeckView(
                deck: gameRunnerViewModel.deck
            )
            DeckView(
                deck: gameRunnerViewModel.gameplayArea
            )
        }
    }

    func getNonCurrentPlayer(bottomPlayerViewModel: PlayerViewModel) -> some View {
        NonBottomPlayerView(
            error: $error,
            bottomPlayerViewModel: bottomPlayerViewModel,
            selectedPlayerViewModel: $selectedPlayerViewModel,
            selectedCardSetViewModel: $selectedCardSetViewModel,
            playerArea: { player in
                MDNonPlayerView(
                    playerViewModel: PlayerViewModel(
                        player: player,
                        hand: gameRunnerViewModel.getHandByPlayer(player) ?? CardCollection()
                    ),
                    playerPlayAreaViewModel: PlayerPlayAreaViewModel(
                        sets: gameRunnerViewModel.getPropertyAreaByPlayer(player)
                    ),
                    selectedCardSetViewModel: $selectedCardSetViewModel,
                    error: $error
                )
            },
            center: {
                centerArea
            }
        )
    }

    func getCurrentPlayer(bottomPlayerViewModel: PlayerViewModel) -> some View {
        BottomPlayerView(
            playerArea: {
                MDPlayerView(
                    playerViewModel: bottomPlayerViewModel,
                    currentPlayerViewModel: bottomPlayerViewModel,
                    playerPlayAreaViewModel: PlayerPlayAreaViewModel(
                        sets: gameRunnerViewModel.getPropertyAreaByPlayer(bottomPlayerViewModel.player)
                    ),
                    selectedCardSetViewModel: $selectedCardSetViewModel,
                    error: $error
                )
            }
        )
    }
    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
                let bottomPlayerViewModel = PlayerViewModel(
                    player: currentPlayer,
                    hand: gameRunnerViewModel.getHandByPlayer(currentPlayer) ?? CardCollection()
                )
                VStack {
                    getNonCurrentPlayer(bottomPlayerViewModel: bottomPlayerViewModel)
                    Spacer()
                    getCurrentPlayer(bottomPlayerViewModel: bottomPlayerViewModel)
                }
            }
            CardPreviewView()
            WinMessageView()
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
        .onAppear(perform: setup)
    }

    private func setup() {
        gameRunnerViewModel.setup()
    }

}
