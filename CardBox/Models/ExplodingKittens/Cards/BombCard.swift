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
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        guard let hand = ekGameRunner.getHandByPlayer(player) else {
            return
        }

        let hasDefuse = hand.containsCard(where: { card in
            guard let card = card as? ExplodingKittensCard else {
                return false
            }

            return card.type == .defuse
        })

        if hasDefuse { ekGameRunner.deckPositionRequest.showRequest(
                callback: { position in
                    hand.removeCard(self)
                    ekGameRunner.deck.addCard(self, offsetFromTop: position - 1)
                },
                maxValue: ekGameRunner.deck.count
            )
        } else {
            player.setOutOfGame(true)
        }
    }
}
