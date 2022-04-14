//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct ExplodingKittensOfflineView: View {
    @StateObject var gameRunnerViewModel = ExplodingKittensGameRunner()
    @State var error = true
    @State var selectedPlayerViewModel: PlayerViewModel?
    @State var cardPreview: Card?

    @ViewBuilder
    var centerArea: some View {
        HStack {
            DeckView(
                deckViewModel: DeckViewModel(
                    deck: gameRunnerViewModel.deck,
                    isPlayDeck: false,
                    gameRunner: gameRunnerViewModel
                ),
                isFaceUp: false
            )
            DeckView(
                deckViewModel: DeckViewModel(
                    deck: gameRunnerViewModel.gameplayArea,
                    isPlayDeck: true,
                    gameRunner: gameRunnerViewModel
                ),
                isFaceUp: true
            )
        }
    }

    func getNonCurrentPlayer(bottomPlayerViewModel: PlayerViewModel) -> some View {
        NonBottomPlayerView(
            error: $error,
            bottomPlayerViewModel: bottomPlayerViewModel,
            selectedPlayerViewModel: $selectedPlayerViewModel,
            selectedCardSetViewModel: .constant(nil),
            playerArea: { player in
                EKPlayerView(
                    playerViewModel: PlayerViewModel(
                        player: player,
                        hand: gameRunnerViewModel.getHandByPlayer(player) ?? CardCollection()
                    ),
                    currentPlayerViewModel: bottomPlayerViewModel,
                    error: $error,
                    selectedPlayerViewModel: $selectedPlayerViewModel
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
                EKPlayerView(
                    playerViewModel: bottomPlayerViewModel,
                    currentPlayerViewModel: bottomPlayerViewModel,
                    error: $error,
                    selectedPlayerViewModel: $selectedPlayerViewModel
                )
            }
        )
    }

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            if let currentPlayer = gameRunnerViewModel.gameState.players.currentPlayer {
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

            if let request = gameRunnerViewModel.gameState.globalRequests.first {
                RequestViewFactory(request: request, isOnline: false)
            }

            WinMessageView()
        }
        .sheet(isPresented: $gameRunnerViewModel.isShowingPeek, onDismiss: dismissPeek) {
            PeekCardsView(cards: gameRunnerViewModel.cardsPeeking)
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
        .onAppear(perform: setup)
    }

    private func setup() {
        gameRunnerViewModel.setup()
    }

    func dismissPeek() {
        gameRunnerViewModel.isShowingPeek = false
    }
}
