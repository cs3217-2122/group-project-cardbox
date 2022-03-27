//
//  BombCard.swift
//  CardBox
//
//  Created by mactest on 26/03/2022.
//

class BombCard: ExplodingKittensCard {
    init() {
        super.init(
            name: "Bomb",
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: .bomb
        )
    }

    override func onDraw(gameRunner: GameRunnerProtocol, player: Player) {
        player.setOutOfGame(true)
    }
}
