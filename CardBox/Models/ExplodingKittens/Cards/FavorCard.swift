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

    override func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {
        guard let targetPlayer = target.getPlayerIfTargetSingle() else {
            return
        }

        guard let hand = gameRunner.getHandByPlayer(player) else {
            return
        }

        guard let targetHand = gameRunner.getHandByPlayer(targetPlayer) else {
            return
        }

        // Temporary hack, will change to update with events
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunner else {
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

        super.onPlay(gameRunner: gameRunner, player: player, on: target)
    }
}
