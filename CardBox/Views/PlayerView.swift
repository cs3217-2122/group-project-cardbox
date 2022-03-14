//
//  PlayerView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct PlayerView: View {
    let viewModel: PlayerViewModel
    @ObservedObject var gameRunner: GameRunner

    init(player: Player, gameRunner: GameRunner) {
        self.viewModel = PlayerViewModel(player: player)
        self.gameRunner = gameRunner
    }

    var body: some View {
        VStack {
            Button(viewModel.player.name) {
                // some hacky testing
                ActionDispatcher.runAction(AddCardToPlayerAction(player: viewModel.player,
                                                                 card: Card(name: "test")),
                                           on: gameRunner)
            }
            ForEach(viewModel.player.hand.getCards()) { card in
                CardView(card: card)
            }
        }
    }
}
