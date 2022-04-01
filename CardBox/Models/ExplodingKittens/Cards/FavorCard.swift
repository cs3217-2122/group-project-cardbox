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


    override func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {

    }
}
