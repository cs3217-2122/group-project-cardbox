//
//  Player.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

class Player {
    private var hand: CardCollection
    private var name: String

    init(name: String) {
        self.hand = CardCollection()
        self.name = name
    }

    func addCard(_ card: Card) {
        self.hand.addCard(card)
    }

    func removeCard(_ card: Card) {
        self.hand.removeCard(card)
    }

    func getHand() -> CardCollection {
        self.hand
    }

    func playCard(_ card: Card, gameRunner: GameRunnerReadOnly, on target: GameplayTarget) {
        guard card.canPlay(by: self, gameRunner: gameRunner, on: target) else {
            return
        }

        // Should call action instead
        gameRunner.executeGameEvents([
            .moveCardToGameplayFromPlayer(card: card, player: self, gameplayArea: gameRunner.gameplayArea)
        ])

        card.onPlay(gameRunner: gameRunner, player: self, on: target)
    }

    var description: String {
        name
    }
}
