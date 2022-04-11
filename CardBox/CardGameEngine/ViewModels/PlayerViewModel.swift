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

    // for online use
    init() {
        let uniqueUserID = UIDevice.current.identifierForVendor?.uuidString
        if let uniqueUserID = uniqueUserID {
            self.player = Player(name: uniqueUserID)
        } else {
            self.player = Player(name: "No unique user ID")
        }
        self.hand = CardCollection()
    }

    func tapCard(card: Card, cardViewModel: CardViewModel, gameRunner: GameRunnerProtocol) {
        guard let currentPlayer = gameRunner.gameState.players.currentPlayer else {
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

    func isCurrentPlayer(gameRunner: GameRunnerProtocol) -> Bool {
        guard let currentPlayer = gameRunner.gameState.players.currentPlayer else {
            return false
        }
        // TODO: Check if online or offline
        return currentPlayer.id == player.id
    }

    func canPlayCard(gameRunner: GameRunnerProtocol) -> Bool {
        player.canPlay(cards: selectedCards, gameRunner: gameRunner)
    }

    func previewCard(card: Card, gameRunner: GameRunnerProtocol) {
        guard let currentPlayer = gameRunner.gameState.players.currentPlayer else {
            return
        }
        if currentPlayer === player {
            gameRunner.setCardPreview(card)
        }
    }

    func unpreviewCard(card: Card, gameRunner: GameRunnerProtocol) {
        guard let currentPlayer = gameRunner.gameState.players.currentPlayer else {
            return
        }
        if currentPlayer === player {
            if gameRunner.cardPreview === card {
                gameRunner.resetCardPreview()
            }
        }
    }

    func canPlayCardOnPlayer(gameRunner: GameRunnerProtocol, target: PlayerViewModel?) -> Bool {
        guard let target = target else {
            return canPlayCard(gameRunner: gameRunner)
        }
        return canPlayCard(gameRunner: gameRunner) && !target.isDead()
    }

    func isDead() -> Bool {
        self.player.isOutOfGame
    }

    func playCards(gameRunner: GameRunnerProtocol, target: PlayerViewModel?, targetCardSet: CardSetViewModel?) {
        guard canPlayCardOnPlayer(gameRunner: gameRunner, target: target) else {
            print("Cannot play card on player (Player is dead)")
            return
        }

        guard let typeOfTargettedCard = player.determineTargetOfCards(selectedCards, gameRunner: gameRunner) else {
            print("Could not determine target")
            return
        }

        switch typeOfTargettedCard {
        case .targetAllPlayersCard:
            player.playCards(selectedCards, gameRunner: gameRunner, on: .all)
        case .targetSinglePlayerCard:
            guard let target = target else {
                print("No target chosen")
                return
            }

            player.playCards(selectedCards, gameRunner: gameRunner, on: .single(target.player))
        case .noTargetCard:
            player.playCards(selectedCards, gameRunner: gameRunner, on: .none)
        case .targetSingleDeckCard:
            player.playCards(selectedCards, gameRunner: gameRunner, on: .deck(targetCardSet?.cards))
        }
    }

    func isSelected(card: Card) -> Bool {
        for selectedCard in selectedCards where selectedCard === card {
            return true
        }
        return false
    }
}
