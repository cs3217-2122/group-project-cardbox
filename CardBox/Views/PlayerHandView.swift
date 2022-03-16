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
    @ObservedObject var gameRunner: GameRunner

    init(playerViewModel: PlayerViewModel, hand: CardCollection, gameRunner: GameRunner) {
        self.playerViewModel = playerViewModel
        self.playerHandViewModel = PlayerHandViewModel(hand: hand)
        self.gameRunner = gameRunner
    }

    var spacing: Double {
        let size = playerHandViewModel.getSize()
        // availableSpace - size * cardWidth / size
        // TODO: figure out spacing
        return Double((400 - size * 150) / size)
    }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(playerHandViewModel.getCards()) { card in
                let cardViewModel = CardViewModel(card: card, isFaceUp: true)
                CardView(cardViewModel: cardViewModel)
                    .onTapGesture {
                        print("tap card")
                        playerViewModel.tapCard(card: card, cardViewModel: cardViewModel, gameRunner: gameRunner)
                    }
            }
        }
    }
}

struct PlayerHandView_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
