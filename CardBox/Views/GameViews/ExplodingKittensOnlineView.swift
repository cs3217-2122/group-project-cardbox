//
//  ExplodingKittensOnlineView.swift
//  CardBox
//
//  Created by Bernard Wan on 1/4/22.
//

import SwiftUI

struct ExplodingKittensOnlineView: View {
    @StateObject var gameRunnerViewModel: ExplodingKittensGameRunner
    @State var error = true
    @State var selectedPlayerViewModel: PlayerViewModel?
    @State var cardPreview: Card?
//    var explodingKittensGameRunnerInitialiser: ExplodingKittensGameRunner
    var localPlayerIndex: Int

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                if let localPlayer = gameRunnerViewModel.players.getPlayerByIndex(localPlayerIndex) {
                    let currentPlayerViewModel = PlayerViewModel(
                        player: localPlayer,
                        hand: gameRunnerViewModel.getHandByPlayer(localPlayer) ?? CardCollection()
                    )
                    NonPlayerView(
                        error: $error, localPlayerIndex: localPlayerIndex,
                        currentPlayerViewModel: currentPlayerViewModel,
                        selectedPlayerViewModel: $selectedPlayerViewModel
                    )

                    Spacer()

                    CurrentPlayerView(
                        error: $error,
                        currentPlayerViewModel: currentPlayerViewModel,
                        selectedPlayerViewModel: $selectedPlayerViewModel
                    )
                }
            }
            CardPreviewView()
            PositionRequestView(cardPositionRequest: $gameRunnerViewModel.deckPositionRequest)
            WinMessageView()
        }
        .sheet(isPresented: $gameRunnerViewModel.isShowingPeek, onDismiss: dismissPeek) {
            PeekCardsView(cards: gameRunnerViewModel.cardsPeeking)
        }
        .environmentObject(gameRunnerViewModel)
//        .onAppear(perform: setup)
    }

    private func setup() {
//        gameRunnerViewModel.initialiseFrom(explodingKittensGameRunnerInitialiser)
    }

    func dismissPeek() {
        gameRunnerViewModel.isShowingPeek = false
    }
}
