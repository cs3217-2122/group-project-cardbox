//
//  DeckView.swift
//  CardBox
//
//  Created by Bernard Wan on 16/3/22.
//

import SwiftUI

struct DeckView: View {
    let deckViewModel: DeckViewModel
    var isFaceUp = false

    var body: some View {
        CardView(cardViewModel: CardViewModel(card: deckViewModel.topCard, isFaceUp: isFaceUp))
    }
}

struct DeckView_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
