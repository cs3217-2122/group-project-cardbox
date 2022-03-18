//
//  PlayerHandView.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct PlayerHandView: View {
    private var playerViewModel: PlayerViewModel
    private let playerHandViewModel: PlayerHandViewModel
    @EnvironmentObject private var gameRunnerViewModel: GameRunner

    init(playerViewModel: PlayerViewModel, hand: CardCollection) {
        self.playerViewModel = playerViewModel
        self.playerHandViewModel = PlayerHandViewModel(hand: hand)
    }

    var spacing: Double {
        let size = playerHandViewModel.getSize()
        // availableSpace - size * cardWidth / size
        // TODO: figure out spacing
        return Double((400 - size * 150) / size)
    }

    var body: some View {
        HStack(spacing: CGFloat(spacing)) {
            ForEach(playerHandViewModel.getCards()) { card in
                let cardViewModel = CardViewModel(card: card, isFaceUp: true)
                CardView(cardViewModel: cardViewModel)
                    .onTapGesture {
                        print("tap card")
                        playerViewModel
                            .tapCard(card: card, cardViewModel: cardViewModel, gameRunner: gameRunnerViewModel)
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
