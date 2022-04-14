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
        gameRunner.executeGameEvents([
            ShuffleDeckEvent(deck: gameRunner.deck)
        ])
    }
}
