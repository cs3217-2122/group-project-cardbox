//
//  PlayerHandView.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct PlayerHandView: View {
    var playerViewModel: PlayerViewModel
    let playerHandViewModel: PlayerHandViewModel
    @EnvironmentObject private var gameRunnerViewModel: ExplodingKittensGameRunner
    @Binding var error: Bool
    let handWidth = 600

    var spacing: Double {
        let size = playerHandViewModel.handSize
        guard size > 0 else {
            return 0
        }
        return Double((handWidth - size * CardView.defaultCardWidth) / size)
    }

    var body: some View {
        HStack(spacing: CGFloat(spacing)) {
            ForEach(playerHandViewModel.getCards()) { card in
                let cardViewModel = CardViewModel(card: card,
                                                  isFaceUp: playerViewModel
                                                    .isCurrentPlayer(gameRunner: gameRunnerViewModel),
                                                  isSelected: playerViewModel.isSelected(card: card))
                CardView(cardViewModel: cardViewModel)
                    .onTapGesture {
                        if playerViewModel.isCurrentPlayer(gameRunner: gameRunnerViewModel) {
                            playerViewModel
                                .tapCard(card: card, cardViewModel: cardViewModel, gameRunner: gameRunnerViewModel)
                            error = !playerViewModel.canPlayCard(gameRunner: gameRunnerViewModel)
                        }
                    }
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

struct PlayerHandView_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
