//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct GameRunnerView: View {

    @StateObject var gameRunnerViewModel = ExplodingKittensGameRunnerInitialiser.getAndSetupGameRunnerInstance()
    @State var error = true
    @State var selectedPlayerViewModel: PlayerViewModel?

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
                    let currentPlayerViewModel = PlayerViewModel(player: currentPlayer)
                    NonCurrentPlayerView(error: $error,
                                         currentPlayerViewModel: currentPlayerViewModel,
                                         selectedPlayerViewModel: $selectedPlayerViewModel)

                    Spacer()

                    CurrentPlayerView(error: $error,
                                      currentPlayerViewModel: currentPlayerViewModel,
                                      selectedPlayerViewModel: $selectedPlayerViewModel)
                }
            }
            CardPreviewView()
            DeckPositionRequestView()
            HandPositionRequestView(selectedPlayerViewModel: $selectedPlayerViewModel)
            CardTypeRequestView(dispatchCardTypeResponse: gameRunnerViewModel.dispatchCardTypeResponse,
                                toggleCardTypeRequestView: gameRunnerViewModel.toggleCardTypeRequest)
        }
        .sheet(isPresented: $gameRunnerViewModel.isShowingPeek, onDismiss: dismissPeek) {
            PeekCardsView(cards: gameRunnerViewModel.cardsPeeking)
        }
        .environmentObject(gameRunnerViewModel)
    }

    func dismissPeek() {
        gameRunnerViewModel.isShowingPeek = false
    }
}
