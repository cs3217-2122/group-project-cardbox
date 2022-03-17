//
//  PlayerDiscardCardsAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct PlayerDiscardCardsAction: CardAction {
    let cardToDiscardCondition: (Card) -> Bool

    init(where cardToDiscardCondition: @escaping (Card) -> Bool) {
        self.cardToDiscardCondition = cardToDiscardCondition
    }

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        let player = args.player
        for card in player.getHand().getCards() where cardToDiscardCondition(card) {
            gameRunner.executeGameEvents([PlayerDiscardCardEvent(player: player, cardToDiscard: card)])
        }

    }
}
