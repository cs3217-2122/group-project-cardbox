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

    init(player: Player, cards: CardCollection, selectedCardSetViewModel: Binding<CardSetViewModel?>,
         error: Binding<Bool>, gameRunner: GameRunnerProtocol) {
        playerViewModel = PlayerViewModel(player: player, hand: CardCollection())
        cardSetViewModel = CardSetViewModel(player: player, cards: cards, isPlayDeck: true,
                                            gameRunner: gameRunner)
        self._error = error
        self._selectedCardSetViewModel = selectedCardSetViewModel
    }

    var spacing: Double {
        let size = cardSetViewModel.size
        guard size > 0 else {
            return 0
        }
        return Double((setHeight - size * Int(gameRunnerViewModel.cardWidth)) / size)
    }

    var body: some View {
        ZStack {
            HStack(spacing: CGFloat(spacing)) {
                ForEach(cardSetViewModel.getCards()) { card in
                    let isSelected = playerViewModel.isSelected(card: card, gameRunner: gameRunnerViewModel)
                    CardView(card: card, isFaceUp: true, isSelected: isSelected,
                             player: playerViewModel.player,
                             bottomPlayer: playerViewModel.player)
                }
            }
            if selectedCardSetViewModel?.cards === cardSetViewModel.cards {
                Text("Chosen Card")
            }
        }
        .onDrop(of: ["cardbox.card"], delegate: cardSetViewModel)
    }
}
