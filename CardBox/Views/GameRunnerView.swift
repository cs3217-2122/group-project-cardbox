//
//  GameRunnerView.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

struct GameRunnerView: View {

    @StateObject var gameRunnerViewModel = ExplodingKittensGameRunnerInitialiser.getAndSetupGameRunnerInstance()

    var body: some View {
        ZStack {
            Color.green
                .ignoresSafeArea()
            VStack {
                if let player3 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(2) {
                    PlayerView(playerViewModel: PlayerViewModel(player: player3))
                        .rotationEffect(.degrees(-180))

                }
                Spacer()
                HStack {
                    if let player4 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(3) {
                        PlayerView(playerViewModel: PlayerViewModel(player: player4))
                            .rotationEffect(.degrees(90))
                    }
                    Spacer()
                    decks
                    playDeck
                    Spacer()
                    if let player2 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(1) {
                        PlayerView(playerViewModel: PlayerViewModel(player: player2))
                            .rotationEffect(.degrees(-90))
                    }
                }
                Button {
                    gameRunnerViewModel.endPlayerTurn()
                } label: {
                    Text("Next")
                        .font(.title)
                        .frame(width: 70, height: 50)
                        .border(Color.black)
                }
                // TODO: Make error appear and fade out when button pressed and invalid combo
                Text("Invalid combination")
                Spacer()

//                if let currentPlayerViewModel = gameRunnerViewModel.players.getCurrentPlayerViewModel() {
                if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
                    PlayerView(playerViewModel: PlayerViewModel(player: currentPlayer))
                }
            }
            if let cardPreview = gameRunnerViewModel.cardPreview {
                CardView(cardViewModel: CardViewModel(card: cardPreview, isFaceUp: true))
            }
        }.environmentObject(gameRunnerViewModel)
    }

    var decks: some View {
        DeckView(deckViewModel: DeckViewModel(deck: gameRunnerViewModel.deck))
    }

    var playDeck: some View {
        DeckView(deckViewModel: DeckViewModel(deck: gameRunnerViewModel.gameplayArea))
    }
}
