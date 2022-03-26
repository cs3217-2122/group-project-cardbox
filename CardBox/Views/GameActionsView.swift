//
//  GameActionsView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct GameActionsView: View {
    @EnvironmentObject private var gameRunnerViewModel: ExplodingKittensGameRunner
    @Binding var error: Bool
    var currentPlayerViewModel: PlayerViewModel
    @Binding var selectedPlayerViewModel: PlayerViewModel?

    var body: some View {
        HStack {
            Button {
                gameRunnerViewModel.endPlayerTurn()
                selectedPlayerViewModel = nil
            } label: {
                Text("End")
                    .font(.title)
                    .frame(width: 70, height: 50)
                    .border(Color.black)
            }
            Button {
                currentPlayerViewModel.playCards(gameRunner: gameRunnerViewModel, target: selectedPlayerViewModel)
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
            selectedPlayerViewModel: .constant(nil)
        )
    }
}
