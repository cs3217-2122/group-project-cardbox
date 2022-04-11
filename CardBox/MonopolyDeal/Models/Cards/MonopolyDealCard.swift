//
//  MonopolyDealCard.swift
//  CardBox
//
//  Created by Temp on 31.03.2022.
//

class MonopolyDealCard: Card {
    typealias MDGameRunnerProtocol = MonopolyDealGameRunnerProtocol
    typealias MDPlayer = MonopolyDealPlayer

    let type: MonopolyDealCardType

    init(
        name: String,
        typeOfTargettedCard: TypeOfTargettedCard,
        type: MonopolyDealCardType,
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
        guard let mdGameRunner = gameRunner as? MDGameRunnerProtocol else {
            return
        }

        guard let mdPlayer = player as? MDPlayer else {
            return
        }

        onDraw(gameRunner: mdGameRunner, player: mdPlayer)
    }

    func onDraw(gameRunner: MDGameRunnerProtocol, player: MDPlayer) {

    }

    override final func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {
        guard let mdGameRunner = gameRunner as? MDGameRunnerProtocol else {
            return
        }

        guard let mdPlayer = player as? MDPlayer else {
            return
        }

        onPlay(gameRunner: mdGameRunner, player: mdPlayer, on: target)
    }

    // To be overridden
    func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
    }
}
