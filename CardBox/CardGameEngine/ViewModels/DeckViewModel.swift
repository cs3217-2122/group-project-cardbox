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

    func playCards() {
        let selectedCards = gameRunner.cardsDragging
        let players = gameRunner.players
        guard let player = players.currentPlayer as? ExplodingKittensPlayer else {
            return
        }

        if selectedCards.count == 1 {
            if selectedCards[0].typeOfTargettedCard == TypeOfTargettedCard.noTargetCard {
                player.playCards(selectedCards, gameRunner: gameRunner, on: .none)
            } else if selectedCards[0].typeOfTargettedCard == TypeOfTargettedCard.targetAllPlayersCard {
                player.playCards(selectedCards, gameRunner: gameRunner, on: .all)
            }
        }
    }
}

extension DeckViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        // guard info.hasItemsConforming(to: ["cardbox.card"]) else {
        //    return false
        // }

        playCards()
        return true

    }

}
