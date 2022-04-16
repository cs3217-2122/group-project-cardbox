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
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @Binding var selectedCardSetViewModel: CardSetViewModel?

    @Binding var error: Bool
    let setHeight = 100

    var spacing: Double {
        let size = cardSetViewModel.size
        guard size > 0 else {
            return 0
        }
        return Double((setHeight - size * CardView.defaultCardWidth) / size)
    }

    var body: some View {
        ZStack {
            HStack(spacing: CGFloat(spacing)) {
                ForEach(cardSetViewModel.getCards()) { card in
                    let isSelected = playerViewModel.isSelected(card: card, gameRunner: gameRunnerViewModel)
                    CardView(card: card, isFaceUp: true, isSelected: isSelected,
                             bottomPlayer: playerViewModel.player)
                        .gesture(
                            DragGesture(minimumDistance: 0.0)
                                .onChanged { _ in
                                    if selectedCardSetViewModel?.cards === cardSetViewModel.cards {
                                        self.selectedCardSetViewModel = nil
                                    } else {
                                        self.selectedCardSetViewModel = cardSetViewModel
                                    }
                                }
                        )
                }
            }
            if selectedCardSetViewModel?.cards === cardSetViewModel.cards {
                Text("Chosen Card")
            }
        }
    }
}
