//
//  CardPreviewView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct CardPreviewView: View {
    @EnvironmentObject var gameRunnerViewModel: ExplodingKittensGameRunner

    var body: some View {
        if let cardPreview = gameRunnerViewModel.cardPreview {
            (CardView(cardViewModel: CardViewModel(card: cardPreview, isFaceUp: true),
                      currentPlayerViewModel: PlayerViewModel())
                .scaleEffect(1.5))
        }
    }
}

struct CardPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        CardPreviewView()
    }
}
