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
    var hand: CardCollection

    init(player: Player, hand: CardCollection) {
        self.player = player
        self.hand = hand
    }

    func tapCard(card: Card, cardViewModel: CardViewModel, gameRunner: ExplodingKittensGameRunner) {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return
        }
        if currentPlayer === player {
            if cardViewModel.isSelected {
                if hand.containsCard(card) {
                    if let indexOf = selectedCards.firstIndex(where: { cardObject in
                        cardObject === card
                    }) {
                        selectedCards.remove(at: indexOf)
                    }
                    cardViewModel.isSelected = false
                }
            } else {
                if hand.containsCard(card) {
                    selectedCards.append(card)
                    cardViewModel.isSelected = true
                }
            }
        }
    }

    func isCurrentPlayer(gameRunner: ExplodingKittensGameRunner) -> Bool {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return false
        }
        return currentPlayer === player
    }

    func canPlayCard(gameRunner: ExplodingKittensGameRunner) -> Bool {
        player.canPlay(cards: selectedCards, gameRunner: gameRunner)
    }

    func previewCard(card: Card, gameRunner: ExplodingKittensGameRunner) {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return
        }
        if currentPlayer === player {
            gameRunner.cardPreview = card
        }
    }

    func unpreviewCard(card: Card, gameRunner: ExplodingKittensGameRunner) {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return
        }
        if currentPlayer === player {
            if gameRunner.cardPreview === card {
                gameRunner.cardPreview = nil
            }
        }
    }

    func canPlayCardOnPlayer(gameRunner: ExplodingKittensGameRunner, target: PlayerViewModel?) -> Bool {
        guard let target = target else {
            return canPlayCard(gameRunner: gameRunner)
        }
        return canPlayCard(gameRunner: gameRunner) && !target.isDead()
    }

    func isDead() -> Bool {
        self.player.isOutOfGame
    }

    func playCards(gameRunner: ExplodingKittensGameRunner, target: PlayerViewModel?) {
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
