//
//  CardSetView.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

struct CardSetView: View {
    var playerViewModel: PlayerViewModel
    let cardSetViewModel: CardSetViewModel
    @EnvironmentObject private var gameRunnerViewModel: ExplodingKittensGameRunner
    @Binding var error: Bool
    let setHeight = 600

    var spacing: Double {
        let size = cardSetViewModel.size
        guard size > 0 else {
            return 0
        }
        return 100
        //return Double((setHeight - size * CardView.defaultCardWidth) / size)
    }

    var body: some View {
        VStack(spacing: CGFloat(spacing)) {
            ForEach(cardSetViewModel.getCards()) { card in
                let cardViewModel = CardViewModel(card: card,
                                                  isFaceUp: true,
                                                  isSelected: playerViewModel.isSelected(card: card))
                CardView(cardViewModel: cardViewModel)
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged { _ in
                                playerViewModel.previewCard(card: card, gameRunner: gameRunnerViewModel)
                            }
                            .onEnded { _ in
                                playerViewModel.unpreviewCard(card: card, gameRunner: gameRunnerViewModel)
                            }
                    )
            }
        }
    }
}
