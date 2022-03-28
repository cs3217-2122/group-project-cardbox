//
//  ExplodingKittensCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class ExplodingKittensCard: Card {
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

    override func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        guard let hand = ekGameRunner.getHandByPlayer(player) else {
            return
        }

        hand.removeCard(self)
        ekGameRunner.gameplayArea.addCard(self, offsetFromTop: 0)
    }
}
