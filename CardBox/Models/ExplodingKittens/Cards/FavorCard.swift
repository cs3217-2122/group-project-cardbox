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
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        guard let targetPlayer = target.getPlayerIfTargetSingle() else {
            return
        }

        guard let hand = ekGameRunner.getHandByPlayer(player) else {
            return
        }

        guard let targetHand = ekGameRunner.getHandByPlayer(targetPlayer) else {
            return
        }

        ekGameRunner.deckPositionRequest.showRequest(
            callback: { position in
                guard let targetCard = targetHand.getCardByIndex(position - 1) else {
                    return
                }

                targetHand.removeCard(targetCard)
                hand.addCard(targetCard)
            },
            maxValue: targetHand.count
        )

        gameRunner.executeGameEvents([
            MoveCardHandToGameplayEvent(player: player, card: self)
        ])
    }
}
