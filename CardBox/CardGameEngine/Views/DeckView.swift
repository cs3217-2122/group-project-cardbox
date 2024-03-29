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

    init(deck: CardCollection, isPlayDeck: Bool, gameRunner: GameRunnerProtocol) {
        deckViewModel = DeckViewModel(
            deck: deck,
            isPlayDeck: isPlayDeck,
            gameRunner: gameRunner
        )
    }

    var isFaceUp: Bool {
        deckViewModel.deck.isFaceUp
    }

    var body: some View {
        CardView(card: deckViewModel.topCard, isFaceUp: isFaceUp, isSelected: false)
            .onDrop(of: ["cardbox.card"], delegate: deckViewModel)
    }
}
