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
        print(selectedCards)
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
    }

    func isCurrentPlayer(gameRunner: GameRunner) -> Bool {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return false
        }
        return currentPlayer === player
    }

    func canPlayCard(gameRunner: GameRunner) -> Bool {
        player.canPlay(cards: selectedCards, gameRunner: gameRunner)
    }

    func previewCard(card: Card, gameRunner: GameRunner) {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return
        }
        if currentPlayer === player {
            gameRunner.cardPreview = card
        }
    }

    func unpreviewCard(card: Card, gameRunner: GameRunner) {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return
        }
        if currentPlayer === player {
            if gameRunner.cardPreview === card {
                gameRunner.cardPreview = nil
            }
        }
    }

    func playCards(gameRunner: GameRunner) {
        // TODO: fix for 2 and 3 cards
        if selectedCards.count == 1 {
            if selectedCards[0].typeOfCard == TypeOfCard.noTargetCard {
                player.playCards(selectedCards, gameRunner: gameRunner, on: .none)
            } else if selectedCards[0].typeOfCard == TypeOfCard.targetAllPlayersCard {
                player.playCards(selectedCards, gameRunner: gameRunner, on: .all)
            } else {
                // TODO: get target
                player.playCards(selectedCards, gameRunner: gameRunner, on: .all)
            }
        } else {
            // 2 or 3 should be played to someone else
            
        }
    }
}
