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
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                if let player3 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(2) {
                    PlayerView(player: player3, gameRunner: gameRunnerViewModel)
                        .rotationEffect(.degrees(-180))

                }
                Spacer()
                HStack {
                    if let player4 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(3) {
                        PlayerView(player: player4, gameRunner: gameRunnerViewModel)
                            .rotationEffect(.degrees(90))

                    }
                    Spacer()
                    decks
                    playDeck
                    Spacer()
                    if let player2 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(1) {
                        PlayerView(player: player2, gameRunner: gameRunnerViewModel)
                            .rotationEffect(.degrees(-90))
                    }
                }
                Button {
                    gameRunnerViewModel.nextPlayer()
                } label: {
                    Text("Next")
                        .font(.title)
                        .frame(width: 70, height: 50)
                        .border(.black)
                }
                // TODO: Make error appear and fade out when button pressed and invalid combo
                Text("Invalid combination")
                Spacer()

                if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
                    PlayerView(player: currentPlayer, gameRunner: gameRunnerViewModel)
                }

            }
            if let cardPreview = gameRunnerViewModel.cardPreview {
                CardView(cardViewModel: CardViewModel(card: cardPreview, isFaceUp: true))
            }
        }
    }

    var decks: some View {
        DeckView(deckViewModel: DeckViewModel(deck: gameRunnerViewModel.deck))
    }

    var playDeck: some View {
        DeckView(deckViewModel: DeckViewModel(deck: gameRunnerViewModel.gameplayArea))
    }
}
