//
//  CardSetViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

class CardSetViewModel: ObservableObject {
    var player: Player
    var cards: CardCollection
    var isPlayDeck: Bool
    var gameRunner: GameRunnerProtocol

    init(player: Player, cards: CardCollection, isPlayDeck: Bool, gameRunner: GameRunnerProtocol) {
        self.player = player
        self.cards = cards
        self.isPlayDeck = isPlayDeck
        self.gameRunner = gameRunner
    }

    func getCards() -> [Card] {
        cards.getCards()
    }

    var topCard: Card? {
        cards.topCard
    }

    var size: Int {
        cards.count
    }
}

extension CardSetViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        let selectedCards = gameRunner.cardsDragging
        let players = gameRunner.gameState.players
        guard let player = players.currentPlayer else {
            return false
        }
        guard self.player.id == player.id else {
            return false
        }
        guard !cards.containsCard(selectedCards[0]) else {
            return false
        }
        guard player.canPlay(cards: selectedCards, gameRunner: gameRunner) else {
            return false
        }
        guard cards.canAdd(selectedCards[0]) else {
            return false
        }
        let playerHand = gameRunner.getHandByPlayer(player)

        guard let player = player as? MonopolyDealPlayer else {
            return false
        }
        if playerHand.containsCard(selectedCards[0]) {
            gameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: selectedCards, fromDeck: playerHand, toDeck: cards),
                IncrementPlayerPlayCountEvent(player: player)])
        } else {
            guard let propertySet = player.getPlayArea(gameRunner: gameRunner)?
                .getPropertySet(from: selectedCards[0]) else {
                return false
            }
            guard !propertySet.isFullSet else {
                return false
            }
            gameRunner.executeGameEvents([
                MoveCardsDeckToDeckEvent(cards: selectedCards, fromDeck: propertySet, toDeck: cards),
                IncrementPlayerPlayCountEvent(player: player)])
        }
        return true
    }
}
