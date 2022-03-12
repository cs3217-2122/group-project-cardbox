//
//  Player.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

class Player {
    private var hand: CardCollection
    private var name: String
    private(set) var isOutOfGame = false

    var description: String {
        name
    }

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
    }

    func endTurn(gameRunner: GameRunnerReadOnly) {
        EndTurnAction().executeGameEvents(gameRunner: gameRunner)
    }

    func setOutOfGame(_ outOfGame: Bool) {
        self.isOutOfGame = outOfGame
    }
}
