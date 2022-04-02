//
//  MonopolyDealGameRunnerView.swift
//  CardBox
//
//  Created by Bernard Wan on 28/3/22.
//

import SwiftUI

struct MonopolyDealGameRunnerView: View {
    @StateObject var gameRunnerViewModel = MonopolyDealGameRunner()
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
                        hand: gameRunnerViewModel.getHandByPlayer(currentPlayer)
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
            WinMessageView()
        }
        .environmentObject(gameRunnerViewModel)
        .onAppear(perform: setup)
    }

    private func setup() {
        gameRunnerViewModel.setup()
    }
}

struct MonopolyDealGameRunnerView_Previews: PreviewProvider {
    static var previews: some View {
        MonopolyDealGameRunnerView()
    }
}
