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
                deck: gameRunnerViewModel.deck
            )
            DeckView(
                deck: gameRunnerViewModel.gameplayArea
            )
        }
        .environmentObject(GameRunnerDelegate(runner: gameRunnerViewModel))
    }

    @ViewBuilder
    func playerArea(player: Player) -> some View {
        if let bottomPlayer = gameRunnerViewModel.players.currentPlayer {
            EKPlayerView(
                player: player,
                hand: gameRunnerViewModel.getHandByPlayer(player)
                ?? CardCollection(),
                bottomPlayer: bottomPlayer,
                error: $error,
                selectedPlayerViewModel: $selectedPlayerViewModel
            )
        }
    }

    func getNonCurrentPlayer(bottomPlayerViewModel: PlayerViewModel) -> some View {
        NonBottomPlayerView(
            error: $error,
            bottomPlayerViewModel: bottomPlayerViewModel,
            selectedPlayerViewModel: $selectedPlayerViewModel,
            selectedCardSetViewModel: .constant(nil),
            playerArea: playerArea,
            center: {
                centerArea
            }
        )
    }

    func getCurrentPlayer(bottomPlayer: Player) -> some View {
        playerArea(player: bottomPlayer)
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
                    getCurrentPlayer(bottomPlayer: currentPlayer)
                }
            }
            CardPreviewView()
            PositionRequestView(cardPositionRequest: $gameRunnerViewModel.deckPositionRequest)
            CardTypeRequestView(cardTypeRequest: $gameRunnerViewModel.cardTypeRequest)
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
