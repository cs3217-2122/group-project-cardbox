//
//  DeckView.swift
//  CardBox
//
//  Created by Bernard Wan on 16/3/22.
//

import SwiftUI

struct DeckView: View {
    let deckViewModel: DeckViewModel
    var isFaceUp: Bool

    var body: some View {
        CardView(cardViewModel: CardViewModel(card: deckViewModel.topCard, isFaceUp: isFaceUp))
            .onDrop(of: ["cardbox.card"], delegate: deckViewModel)
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
