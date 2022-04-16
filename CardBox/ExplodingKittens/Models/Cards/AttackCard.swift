//
//  AttackCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//
import Foundation

class AttackCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Attack",
            typeOfTargettedCard: .noTargetCard,
            type: .attack
        )
    }

    init(id: UUID) {
        super.init(
            id: id,
            name: "Attack",
            typeOfTargettedCard: .noTargetCard,
            type: .attack
        )
    }

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: ExplodingKittensPlayer, on target: GameplayTarget) {

        guard let nextPlayer = gameRunner.getNextPlayer() as? ExplodingKittensPlayer else {
            return
        }

        gameRunner.executeGameEvents([
            CustomizedGameEvent(customizedGameEvent: IncrementAttackCountEvent(player: nextPlayer)),
            AdvanceNextPlayerEvent()
        ])
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
