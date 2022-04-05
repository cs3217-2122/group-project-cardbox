//
//  SkipCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//
import Foundation

class SkipCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Skip",
            typeOfTargettedCard: .noTargetCard,
            type: .skip
        )
    }

    init(id: UUID) {
        super.init(
            id: id,
            name: "Skip",
            typeOfTargettedCard: .noTargetCard,
            type: .skip
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {
        guard let playerHand = gameRunner.getHandByPlayer(player) else {
            return
        }

        gameRunner.executeGameEvents([
            AdvanceNextPlayerEvent()
        ])
    }
}
