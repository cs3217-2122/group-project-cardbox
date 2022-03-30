//
//  DefuseCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class DefuseCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Defuse",
            typeOfTargettedCard: .noTargetCard,
            type: .defuse
        )
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func onDraw(gameRunner: GameRunnerProtocol, player: Player) {
    }
}
