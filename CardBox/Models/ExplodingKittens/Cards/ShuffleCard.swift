//
//  ShuffleCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class ShuffleCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Shuffle",
            typeOfTargettedCard: .noTargetCard,
            type: .shuffle
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {
        gameRunner.executeGameEvents([
            ShuffleDeckEvent(deck: gameRunner.deck)
        ])

        super.onPlay(gameRunner: gameRunner, player: player, on: target)
    }
}
