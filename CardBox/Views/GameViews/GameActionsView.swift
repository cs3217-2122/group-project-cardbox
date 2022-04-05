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

    var body: some View {
        HStack {
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
                }
            } label: {
                Text("Play")
                    .font(.title)
                    .frame(width: 70, height: 50)
                    .border(Color.black)
            }
        }
        Text(error ? "Invalid combination" : "Valid combination")
            .foregroundColor(error ? Color.red : Color.black)
    }
}

struct GameActionsView_Previews: PreviewProvider {
    static var previews: some View {
        GameActionsView(
            error: .constant(false),
            currentPlayerViewModel: PlayerViewModel(
                player: Player(name: "test"),
                hand: CardCollection()
            ),
            selectedPlayerViewModel: .constant(nil),
            selectedCardSetViewModel: .constant(nil)
        )
    }
}
