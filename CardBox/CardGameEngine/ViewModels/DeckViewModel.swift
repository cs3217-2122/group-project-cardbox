//
//  DeckViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 16/3/22.
//
import SwiftUI

class DeckViewModel: ObservableObject {
    var deck: CardCollection
    var isPlayDeck: Bool
    var gameRunner: GameRunnerProtocol

    init(deck: CardCollection, isPlayDeck: Bool, gameRunner: GameRunnerProtocol) {
        self.deck = deck
        self.isPlayDeck = isPlayDeck
        self.gameRunner = gameRunner
    }

    func setGameRunner(gameRunner: GameRunnerProtocol) {
        self.gameRunner = gameRunner
    }

    func getCards() -> [Card] {
        deck.getCards()
    }

    var topCard: Card? {
        deck.topCard
    }

}

extension DeckViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        let selectedCards = gameRunner.cardsDragging
        let players = gameRunner.gameState.players
        guard let player = players.currentPlayer else {
            return false
        }

        if isPlayDeck {
            if selectedCards[0].typeOfTargettedCard == TypeOfTargettedCard.noTargetCard {
                player.playCards(selectedCards, gameRunner: gameRunner, on: .none)
            } else if selectedCards[0].typeOfTargettedCard == TypeOfTargettedCard.targetAllPlayersCard {
                player.playCards(selectedCards, gameRunner: gameRunner, on: .all)
            }
        } else {

        }
        return true
    }

}
