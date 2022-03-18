//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct GameRunnerView: View {
    @StateObject var viewModel = ExplodingKittensGameRunnerInitialiser.getAndSetupGameRunnerInstance()

    var body: some View {
        currentPlayer
        deck
        player
        Button("End Turn", action: viewModel.endPlayerTurn)
<<<<<<< HEAD
=======
        if viewModel.isShowingDeckPositionRequest {
            DeckPositionView(gameRunner: viewModel)
        }
>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753
    }

    var deck: some View {
        EmptyView()
    }

    var currentPlayer: some View {
        Text("Current Player: " + (viewModel.players.currentPlayer?.description ?? ""))
    }

    var player: some View {
        HStack {
            ForEach(viewModel.players.getPlayers()) { player in
                PlayerView(player: player, gameRunner: viewModel)
            }
        }
    }
}
