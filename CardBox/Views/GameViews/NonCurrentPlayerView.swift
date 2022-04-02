//
//  NonCurrentPlayerView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct NonCurrentPlayerView: View {
    @EnvironmentObject private var gameRunnerViewModel: ExplodingKittensGameRunner
    @Binding var error: Bool
    var currentPlayerViewModel: PlayerViewModel
    @Binding var selectedPlayerViewModel: PlayerViewModel?

    var body: some View {
        VStack {
            if let player3 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(2) {
                PlayerView(
                    playerViewModel: PlayerViewModel(
                        player: player3,
                        hand: gameRunnerViewModel.getHandByPlayer(player3) ?? CardCollection()
                    ),
                    error: $error,
                    selectedPlayerViewModel: $selectedPlayerViewModel
                )
                .rotationEffect(.degrees(-180))

            }
            Spacer()
            middlePart
            GameActionsView(error: $error,
                            currentPlayerViewModel: currentPlayerViewModel,
                            selectedPlayerViewModel: $selectedPlayerViewModel)
        }
    }

    var middlePart: some View {
        HStack {
            if let player4 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(3) {
                PlayerView(
                    playerViewModel: PlayerViewModel(
                        player: player4,
                        hand: gameRunnerViewModel.getHandByPlayer(player4) ?? CardCollection()
                    ),
                    error: $error,
                    selectedPlayerViewModel: $selectedPlayerViewModel
                )
                .rotationEffect(.degrees(90))
            }
            Spacer()
            decks
            Spacer()
            if let player2 = gameRunnerViewModel.players.getPlayerByIndexAfterCurrent(1) {
                PlayerView(
                    playerViewModel: PlayerViewModel(
                        player: player2,
                        hand: gameRunnerViewModel.getHandByPlayer(player2) ?? CardCollection()
                    ),
                    error: $error,
                    selectedPlayerViewModel: $selectedPlayerViewModel
                )
                .rotationEffect(.degrees(-90))
            }
        }
    }
    var decks: some View {
        HStack {
            DeckView(deckViewModel:
                        DeckViewModel(deck: gameRunnerViewModel.deck,
                                      isPlayDeck: false, gameRunner: gameRunnerViewModel),
                     isFaceUp: false)
            DeckView(deckViewModel:
                        DeckViewModel(deck: gameRunnerViewModel.gameplayArea,
                                      isPlayDeck: true, gameRunner: gameRunnerViewModel),
                     isFaceUp: true)
        }

    }
}

struct NonCurrentPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        NonCurrentPlayerView(
            error: .constant(false),
            currentPlayerViewModel: PlayerViewModel(
                player: Player(name: "test"),
                hand: CardCollection()
            ),
            selectedPlayerViewModel: .constant(nil)
        )
    }
}
