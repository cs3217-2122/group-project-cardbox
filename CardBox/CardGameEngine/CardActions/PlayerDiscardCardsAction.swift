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

<<<<<<< HEAD
    func executeGameEvents(gameRunner: GameRunnerReadOnly, player: Player, target: GameplayTarget) {
=======
    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        let player = args.player
>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753
        for card in player.getHand().getCards() where cardToDiscardCondition(card) {
            gameRunner.executeGameEvents([PlayerDiscardCardEvent(player: player, cardToDiscard: card)])
        }

    }
}
