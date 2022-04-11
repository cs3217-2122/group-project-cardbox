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
        deckViewModel.setGameRunner(gameRunner: gameRunnerDelegate.runner)
    }

    var isFaceUp: Bool {
        deckViewModel.deck.isFaceUp
    }

    var body: some View {
        CardView(cardViewModel: CardViewModel(card: deckViewModel.topCard, isFaceUp: isFaceUp),
                 currentPlayerViewModel: PlayerViewModel())
            .onDrop(of: ["cardbox.card"], delegate: deckViewModel)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
