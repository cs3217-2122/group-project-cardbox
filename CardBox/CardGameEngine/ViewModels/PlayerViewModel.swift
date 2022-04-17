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

    var handSize: Int {
        hand.count
    }

    func getCards() -> [Card] {
        hand.getCards()
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
        guard let currentPlayer = gameRunner.gameState.players.currentPlayer else {

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
        guard let currentPlayer = gameRunner.gameState.players.currentPlayer else {
            return false
        }
        return currentPlayer.id == player.id
    }

    func canPlayCard(gameRunner: GameRunnerProtocol) -> Bool {
        // Might need to check for other player card sets
        player.canPlay(cards: gameRunner.cardsSelected, gameRunner: gameRunner)
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

        guard !target.isDead() else {
            let message = Message(
                title: "Cannot play on dead target",
                description: "Please deselect the target",
                type: .error
            )
            gameRunner.executeGameEvents([ShowMessageEvent(message: message)])
            return false
        }

        return canPlayCard(gameRunner: gameRunner)
    }

    func isDead() -> Bool {
        self.player.isOutOfGame
    }

    func playCards(gameRunner: GameRunnerProtocol, target: PlayerViewModel?, targetCardSet: CardSetViewModel?) {
        guard canPlayCardOnPlayer(gameRunner: gameRunner, target: target) else {
            return
        }

        guard let typeOfTargettedCard = player.determineTargetOfCards(
            gameRunner.cardsSelected, gameRunner: gameRunner) else {
            let message = Message(
                title: "Cannot determine target of card",
                description: "Please select a target",
                type: .error
            )
            gameRunner.executeGameEvents([ShowMessageEvent(message: message)])
            return
        }

        switch typeOfTargettedCard {
        case .targetAllPlayersCard:
            player.playCards(gameRunner.cardsSelected, gameRunner: gameRunner, on: .all)
        case .targetSinglePlayerCard:
            guard let target = target else {
                let message = Message(
                    title: "No player chosen",
                    description: "Please select a player to target",
                    type: .error
                )
                gameRunner.executeGameEvents([ShowMessageEvent(message: message)])
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
