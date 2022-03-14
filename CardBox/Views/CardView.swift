//
//  CardView.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

struct CardView: View {
    let viewModel: CardViewModel

    init(card: Card) {
        self.viewModel = CardViewModel(card: card)
    }

    var body: some View {
        Text(viewModel.card.name)
    }
}
