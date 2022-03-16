//
//  PlayerViewModel.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//
import SwiftUI

class PlayerViewModel: ObservableObject {
    var player: Player
    var selectedCards: [Card] = []

    init(player: Player) {
        self.player = player
    }

    func tapCard(card: Card, cardViewModel: CardViewModel, gameRunner: GameRunner) {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return
        }
        print("hello")
        if currentPlayer === player {
            print("in")
            print(selectedCards)
            if cardViewModel.isSelected {
                if player.hand.contains(card: card) {
                    if let indexOf = selectedCards.firstIndex(where: { cardObject in
                        cardObject === card
                    }) {
                        selectedCards.remove(at: indexOf)
                    }
                    cardViewModel.isSelected = false
                }
            } else {
                if player.hand.contains(card: card) {
                    print("contains")
                    selectedCards.append(card)
                    cardViewModel.isSelected = true
                }
            }
        }

        // else ignore
    }
}
