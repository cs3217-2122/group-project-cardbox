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
        if currentPlayer === player {
            if cardViewModel.isSelected {
                if player.hand.containsCard(card) {
                    if let indexOf = selectedCards.firstIndex(where: { cardObject in
                        cardObject === card
                    }) {
                        selectedCards.remove(at: indexOf)
                    }
                    cardViewModel.isSelected = false
                }
            } else {
                if player.hand.containsCard(card) {
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

    func canPlayCardOnPlayer(gameRunner: GameRunner, target: PlayerViewModel?) -> Bool {
        guard let target = target else {
            return canPlayCard(gameRunner: gameRunner)
        }
        return canPlayCard(gameRunner: gameRunner) && !target.isDead()
    }

    func isDead() -> Bool {
        self.player.isOutOfGame
    }

    func playCards(gameRunner: GameRunner, target: PlayerViewModel?) {
        guard canPlayCardOnPlayer(gameRunner: gameRunner, target: target) else {
            print("Cannot play card on player (Player is dead)")
            return
        }

        if selectedCards.count == 1 {
            if selectedCards[0].typeOfTargettedCard == TypeOfTargettedCard.noTargetCard {
                player.playCards(selectedCards, gameRunner: gameRunner, on: .none)
            } else if selectedCards[0].typeOfTargettedCard == TypeOfTargettedCard.targetAllPlayersCard {
                player.playCards(selectedCards, gameRunner: gameRunner, on: .all)
            } else {
                guard let target = target else {
                    print("No target chosen")
                    return
                }
                player.playCards(selectedCards, gameRunner: gameRunner, on: .single(target.player))
            }
        } else {
            guard let target = target else {
                print("No target chosen")
                return
            }
            player.playCards(selectedCards, gameRunner: gameRunner, on: .single(target.player))
        }
    }

    func isSelected(card: Card) -> Bool {
        for selectedCard in selectedCards where selectedCard === card {
            return true
        }
        return false
    }
}
