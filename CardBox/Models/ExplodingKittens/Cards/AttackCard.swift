//
//  AttackCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class AttackCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Attack",
            typeOfTargettedCard: .noTargetCard,
            type: .attack
        )
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {
        guard let nextPlayer = gameRunner.getNextPlayer() as? ExplodingKittensPlayer else {
            return
        }

        nextPlayer.incrementAttackCount()
        gameRunner.executeGameEvents([
            AdvanceNextPlayerEvent()
        ])
    }
}
