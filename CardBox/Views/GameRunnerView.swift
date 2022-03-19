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

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
                    let currentPlayerViewModel = PlayerViewModel(player: currentPlayer)
                    NonCurrentPlayerView(error: $error, currentPlayerViewModel: currentPlayerViewModel)

                    Spacer()

                    CurrentPlayerView(error: $error, currentPlayerViewModel: currentPlayerViewModel)
                }
            }
            if let cardPreview = gameRunnerViewModel.cardPreview {
                CardView(cardViewModel: CardViewModel(card: cardPreview, isFaceUp: true))
                    .scaleEffect(1.5)
            }
        }.environmentObject(gameRunnerViewModel)
    }
}
