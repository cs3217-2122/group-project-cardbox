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

    // To be overwritten
    override func onPlay(gameRunner: GameRunnerReadOnly, player: Player, on target: GameplayTarget) {
        gameRunner.executeGameEvents([
            ShuffleDeckEvent()
        ])
    }
}
