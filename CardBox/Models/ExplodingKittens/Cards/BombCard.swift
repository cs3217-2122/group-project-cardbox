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

    override func onDraw(gameRunner: EKGameRunnerProtocol, player: EKPlayer) {
        guard let hand = gameRunner.getHandByPlayer(player) else {
            return
        }

        let hasDefuse = hand.containsCard(where: { card in
            guard let card = card as? ExplodingKittensCard else {
                return false
            }

            return card.type == .defuse
        })

        // Temporary hack, will change to update with events
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        if hasDefuse { ekGameRunner.deckPositionRequest.showRequest(
                callback: { position in
                    hand.removeCard(self)
                    ekGameRunner.deck.addCard(self, offsetFromTop: position - 1)
                },
                maxValue: gameRunner.deck.count
            )
        } else {
            player.setOutOfGame(true)
        }
    }
}
