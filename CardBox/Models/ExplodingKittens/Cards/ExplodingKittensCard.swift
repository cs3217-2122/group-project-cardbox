//
//  ExplodingKittensCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class ExplodingKittensCard: Card {
    typealias EKGameRunnerProtocol = ExplodingKittensGameRunnerProtocol
    typealias EKPlayer = ExplodingKittensPlayer

    let type: ExplodingKittensCardType

    init(
        name: String,
        typeOfTargettedCard: TypeOfTargettedCard,
        type: ExplodingKittensCardType,
        cardDescription: String = ""
    ) {
        self.type = type
        super.init(
            name: name,
            typeOfTargettedCard: typeOfTargettedCard,
            cardDescription: cardDescription
        )
    }

    override final func onDraw(gameRunner: GameRunnerProtocol, player: Player) {
        guard let ekGameRunner = gameRunner as? EKGameRunnerProtocol else {
            return
        }

        guard let ekPlayer = player as? EKPlayer else {
            return
        }

        onDraw(gameRunner: ekGameRunner, player: ekPlayer)
    }

    func onDraw(gameRunner: EKGameRunnerProtocol, player: EKPlayer) {

    }

    override final func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {
        guard let ekGameRunner = gameRunner as? EKGameRunnerProtocol else {
            return
        }

        guard let ekPlayer = player as? EKPlayer else {
            return
        }

        onPlay(gameRunner: ekGameRunner, player: ekPlayer, on: target)
    }

    // To be overridden
    func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {
    }
}
