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

    // To be overwritten
    override func onDraw(gameRunner: GameRunnerReadOnly, player: Player) {
    }

    // To be overwritten
    override func onPlay(gameRunner: GameRunnerReadOnly, player: Player, on target: GameplayTarget) {
        guard let ekPlayer = player as? ExplodingKittensPlayer else {
            return
        }

        ekPlayer.incrementAttackCount()
    }
}
