//
//  Player.swift
//  CardBox
//
//  Created by mactest on 10/03/2022.
//

import Foundation

class Player: Identifiable {
    let id: UUID
    private(set) var name: String
    private(set) var isOutOfGame = false

    private(set) var cardsPlayed = 0

    var description: String {
        name
    }

    convenience init(name: String) {
        self.init(id: UUID(), name: name)
    }

    // for online game
    init(id: UUID, name: String, isOutOfGame: Bool, cardsPlayed: Int) {
        self.id = id
        self.name = name
        self.isOutOfGame = isOutOfGame
        self.cardsPlayed = cardsPlayed
    }

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }

    // To be overwritten
    func canPlay(cards: [Card], gameRunner: GameRunnerProtocol) -> Bool {
        true
    }

    // To be overwritten
    func playCards(_ cards: [Card], gameRunner: GameRunnerProtocol, on target: GameplayTarget) {
    }

    func endTurn(gameRunner: GameRunnerProtocol) {
        guard !isOutOfGame else {
            return
        }

    }

    func setOutOfGame(_ outOfGame: Bool) {
        self.isOutOfGame = outOfGame
    }

    func incrementCardsPlayed() {
        self.cardsPlayed += 1
    }

    func resetCardsPlayed() {
        self.cardsPlayed = 0
    }
}
