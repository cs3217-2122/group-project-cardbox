//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct GameRunnerView: View {

    @StateObject var gameRunnerViewModel = ExplodingKittensGameRunner.generateGameRunner()

    var body: some View {
        VStack {
            if let player3 = gameRunnerViewModel.players.getPlayerByIndex(2) {
                PlayerView(player: player3, gameRunner: gameRunnerViewModel)
                    .rotationEffect(.degrees(-180))

            }
            Spacer()
            HStack {
                if let player4 = gameRunnerViewModel.players.getPlayerByIndex(3) {
                    PlayerView(player: player4, gameRunner: gameRunnerViewModel)
                        .rotationEffect(.degrees(90))

                }
                Spacer()
                decks
                Spacer()
                if let player2 = gameRunnerViewModel.players.getPlayerByIndex(1) {
                    PlayerView(player: player2, gameRunner: gameRunnerViewModel)
                        .rotationEffect(.degrees(-90))
                }
            }
            Spacer()
            if let player1 = gameRunnerViewModel.players.getPlayerByIndex(0) {
                PlayerView(player: player1, gameRunner: gameRunnerViewModel)
            }

        }
        .environmentObject(gameRunnerViewModel)
    }

    var decks: some View {
        DeckView(deckViewModel: DeckViewModel(deck: gameRunnerViewModel.deck))
    }
}
