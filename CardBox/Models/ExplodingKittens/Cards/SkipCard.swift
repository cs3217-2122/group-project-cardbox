//
//  SkipCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

class SkipCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Skip",
            typeOfTargettedCard: .noTargetCard,
            type: .skip
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {
        gameRunner.executeGameEvents([
            AdvanceNextPlayerEvent()
        ])

        super.onPlay(gameRunner: gameRunner, player: player, on: target)
    }
}
