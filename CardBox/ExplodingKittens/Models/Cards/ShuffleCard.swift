//
//  ShuffleCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//
import Foundation

class ShuffleCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Shuffle",
            typeOfTargettedCard: .noTargetCard,
            type: .shuffle
        )
    }

    init(id: UUID) {
        super.init(
            id: id,
            name: "Shuffle",
            typeOfTargettedCard: .noTargetCard,
            type: .shuffle
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {

        guard let gameState = gameRunner.gameState as? ExplodingKittensGameState else {
            return
        }

        gameRunner.executeGameEvents([
            ShuffleDeckEvent(deck: gameState.deck)
        ])
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
