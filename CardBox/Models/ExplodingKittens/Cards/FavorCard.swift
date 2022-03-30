//
//  FavorCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

class FavorCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Favor",
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: .favor
        )
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {

    }
}
