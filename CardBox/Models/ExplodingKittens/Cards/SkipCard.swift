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

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {
        gameRunner.executeGameEvents([
            AdvanceNextPlayerEvent()
        ])
    }
}
