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
                deck: gameRunnerViewModel.deck, isPlayDeck: true, gameRunner: gameRunnerViewModel
            )
            DeckView(
                deck: gameRunnerViewModel.gameplayArea, isPlayDeck: true, gameRunner: gameRunnerViewModel
            )
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
    }

    @ViewBuilder
    func playerArea(player: Player, rotateBy: Double) -> some View {
        if let bottomPlayer = gameRunnerViewModel.gameState.players.currentPlayer {
            EKPlayerView(
                player: player,
                hand: gameRunnerViewModel.getHandByPlayer(player),
                bottomPlayer: bottomPlayer,
                rotateBy: rotateBy,
                error: $error,
                selectedPlayerViewModel: $selectedPlayerViewModel
            )
        }
    }

    func getNonCurrentPlayer(bottomPlayer: Player) -> some View {
        NonBottomPlayerView(
            bottomPlayer: bottomPlayer,
            selectedPlayerViewModel: $selectedPlayerViewModel,
            selectedCardSetViewModel: .constant(nil),
            error: $error,
            playerArea: playerArea,
            center: {
                centerArea
            }
        )
    }

    func getCurrentPlayer(bottomPlayer: Player) -> some View {
        playerArea(player: bottomPlayer, rotateBy: 0.0)
    }

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()

            if let currentPlayer = gameRunnerViewModel.gameState.players.currentPlayer {

                VStack {
                    getNonCurrentPlayer(bottomPlayer: currentPlayer)
                    Spacer()
                    getCurrentPlayer(bottomPlayer: currentPlayer)
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
