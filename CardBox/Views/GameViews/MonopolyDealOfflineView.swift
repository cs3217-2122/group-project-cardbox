//
//  MonopolyDealOfflineView.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

struct MonopolyDealOfflineView: View {
    @StateObject var gameRunnerViewModel = ExplodingKittensGameRunner()// MonopolyDealGameRunner()
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
                        error: $error,
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
        .environmentObject(gameRunnerViewModel)
        .onAppear(perform: setup)
    }

    private func setup() {
        gameRunnerViewModel.setup()
    }

}