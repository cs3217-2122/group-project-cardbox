//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct GameRunnerView: View {

    @StateObject var viewModel = ExplodingKittensGameRunner.generateGameRunner()

    var body: some View {
        VStack {
            if let player3 = viewModel.players.getPlayerByIndex(2) {
                PlayerView(player: player3, gameRunner: viewModel)
                    .rotationEffect(.degrees(-180))

            }
            Spacer()
            HStack {
                if let player4 = viewModel.players.getPlayerByIndex(3) {
                    PlayerView(player: player4, gameRunner: viewModel)
                        .rotationEffect(.degrees(90))

                }
                Spacer()
                decks
                playDeck
                Spacer()
                if let player2 = viewModel.players.getPlayerByIndex(1) {
                    PlayerView(player: player2, gameRunner: viewModel)
                        .rotationEffect(.degrees(-90))
                }
            }
            Spacer()
            if let player1 = viewModel.players.getPlayerByIndex(0) {
                PlayerView(player: player1, gameRunner: viewModel)
            }

        }
    }

    var decks: some View {
        DeckView(viewModel: DeckViewModel(deck: viewModel.deck))
    }

    var playDeck: some View {
        DeckView(viewModel: DeckViewModel(deck: viewModel.gameplayArea))
    }

//    var player: some View {
        // HStack {
          //  ForEach(viewModel.players.getPlayers()) { player in
            //    PlayerView(player: player, gameRunner: viewModel)
            // }
        // }
//        PlayerView(player: viewModel.players.getPlayers()[0], gameRunner: viewModel)
//    }
}
