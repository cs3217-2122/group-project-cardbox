//
//  PlayerViewModel.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//
import SwiftUI

class PlayerViewModel: ObservableObject {
    var player: Player
    var hand: CardCollection

    init(player: Player, hand: CardCollection) {
        self.player = player
        self.hand = hand
    }

    func setHand(hand: CardCollection) {
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

    func tapCard(card: Card, gameRunner: GameRunnerProtocol) {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return
        }
        // gameRunner.selectedCards and gameRunner.canTap(card)
        // not in selectedCards and canTap

        if currentPlayer === player {
            if gameRunner.cardsSelected.contains(card) {
                if let indexOf = gameRunner.cardsSelected.firstIndex(where: { cardObject in
                    cardObject === card
                }) {
                    gameRunner.cardsSelected.remove(at: indexOf)
                }
            } else {
                gameRunner.cardsSelected.append(card)
            }
        }
    }

    func isCurrentPlayer(gameRunner: GameRunnerProtocol) -> Bool {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return false
        }
        // TODO: Check if online or offline
        return currentPlayer.id == player.id
    }

    func canPlayCard(gameRunner: GameRunnerProtocol) -> Bool {
        // hand.containsCard
        player.canPlay(cards: gameRunner.cardsSelected, gameRunner: gameRunner)
    }

    func previewCard(card: Card, gameRunner: GameRunnerProtocol) {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
            return
        }
        if currentPlayer === player {
            gameRunner.setCardPreview(card)
        }
    }

    func unpreviewCard(card: Card, gameRunner: GameRunnerProtocol) {
        guard let currentPlayer = gameRunner.players.currentPlayer else {
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

        guard let typeOfTargettedCard = player.determineTargetOfCards(
            gameRunner.cardsSelected, gameRunner: gameRunner) else {
            print("Could not determine target")
            return
        }

        switch typeOfTargettedCard {
        case .targetAllPlayersCard:
            player.playCards(gameRunner.cardsSelected, gameRunner: gameRunner, on: .all)
        case .targetSinglePlayerCard:
            guard let target = target else {
                print("No target chosen")
                return
            }

            player.playCards(gameRunner.cardsSelected, gameRunner: gameRunner, on: .single(target.player))
        case .noTargetCard:
            player.playCards(gameRunner.cardsSelected, gameRunner: gameRunner, on: .none)
        case .targetSingleDeckCard:
            player.playCards(gameRunner.cardsSelected, gameRunner: gameRunner, on: .deck(targetCardSet?.cards))
        }
    }

    func isSelected(card: Card, gameRunner: GameRunnerProtocol) -> Bool {
        for selectedCard in gameRunner.cardsSelected where selectedCard === card {
            return true
        }
        return false
    }
}
