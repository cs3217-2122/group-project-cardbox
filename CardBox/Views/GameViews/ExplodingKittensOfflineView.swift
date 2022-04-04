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

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
                    let currentPlayerViewModel = PlayerViewModel(
                        player: currentPlayer,
                        hand: gameRunnerViewModel.getHandByPlayer(currentPlayer) ?? CardCollection()
                    )
                    NonCurrentPlayerView(
                        error: $error, currentPlayerViewModel: currentPlayerViewModel,
                        selectedPlayerViewModel: $selectedPlayerViewModel
                    )

                    Spacer()

                    CurrentPlayerView(
                        error: $error, currentPlayerViewModel: currentPlayerViewModel,
                        selectedPlayerViewModel: $selectedPlayerViewModel
                    )
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
        .environmentObject(gameRunnerViewModel)
        .onAppear(perform: setup)
    }

    private func setup() {
        gameRunnerViewModel.setup()
    }

    func dismissPeek() {
        gameRunnerViewModel.isShowingPeek = false
    }
}
