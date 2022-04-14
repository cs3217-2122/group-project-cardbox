//
//  DeckView.swift
//  CardBox
//
//  Created by Bernard Wan on 16/3/22.
//

import SwiftUI

struct DeckView: View {
    @EnvironmentObject var gameRunnerDelegate: GameRunnerDelegate
    let deckViewModel: DeckViewModel

    init(deck: CardCollection) {
        deckViewModel = DeckViewModel(
            deck: deck,
            isPlayDeck: false,
            gameRunner: ExplodingKittensGameRunner()
        )
    }

    var isFaceUp: Bool {
        deckViewModel.deck.isFaceUp
    }

    var body: some View {
        CardView(card: deckViewModel.topCard, isFaceUp: isFaceUp, isSelected: false)
            .onDrop(of: ["cardbox.card"], delegate: deckViewModel)
            .onAppear {
                deckViewModel.setGameRunner(gameRunner: gameRunnerDelegate.runner)
            }
    }
}
