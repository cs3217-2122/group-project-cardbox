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
        guard let playerHand = gameRunner.getHandByPlayer(player) else {
            return
        }

        guard let defuseCard = playerHand.getCard(where: {
            guard let ekCard = $0 as? ExplodingKittensCard else {
                return false
            }

            return ekCard.type == .defuse
        }) else {
            player.setOutOfGame(true)
            return
        }

        // Temporary hack, will change to update with events
        guard let ekGameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        ekGameRunner.deckPositionRequest.showRequest(
            callback: { position in
                ekGameRunner.executeGameEvents([
                    MoveCardsDeckToDeckEvent(cards: [defuseCard],
                                             fromDeck: playerHand,
                                             toDeck: ekGameRunner.gameplayArea),
                    MoveCardsDeckToDeckEvent(cards: [self],
                                             fromDeck: playerHand,
                                             toDeck: ekGameRunner.deck,
                                             offsetFromTop: position - 1)
                ])
            },
            maxValue: gameRunner.deck.count
        )
    }
}
