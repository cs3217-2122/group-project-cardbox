//
//  RandomCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

class RandomCard: ExplodingKittensCard {
    init(type: ExplodingKittensCardType) {
        super.init(
            name: "Random",
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: type
        )
    }

    override func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {

    }
}
