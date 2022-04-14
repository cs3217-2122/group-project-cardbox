//
//  GameActionsView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct GameActionsView: View {
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @Binding var error: Bool
    var currentPlayerViewModel: PlayerViewModel
    @Binding var selectedPlayerViewModel: PlayerViewModel?
    @Binding var selectedCardSetViewModel: CardSetViewModel?

    var endButton: some View {
        Button {
            if currentPlayerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                gameRunnerViewModel.endPlayerTurn()
                selectedPlayerViewModel = nil
            }
        } label: {
            Text("End")
                .font(.title)
                .frame(width: 70, height: 50)
                .border(Color.black)
        }
    }

    var playButton: some View {
        Button {
            if currentPlayerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                currentPlayerViewModel.playCards(
                    gameRunner: gameRunnerViewModel,
                    target: selectedPlayerViewModel,
                    targetCardSet: selectedCardSetViewModel
                )
                // Reset selected on play
                self.selectedCardSetViewModel = nil
                self.selectedPlayerViewModel = nil
                gameRunnerViewModel.cardsSelected = []
            }
        } label: {
            Text("Play")
                .font(.title)
                .frame(width: 70, height: 50)
                .border(Color.black)
        }
    }

    var body: some View {
        HStack {
            endButton
            playButton
        }
        Text(error ? "Invalid combination" : "Valid combination")
            .foregroundColor(error ? Color.red : Color.black)
    }
}
