//
//  PlayerTakenChosenCardFromPlayerCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 19/3/22.
//

struct PlayerTakenChosenCardFromPlayerCardAction: CardAction {
    
    let cardPredicate: (Card) -> Bool

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        let targetPlayerWrapped = args.target.getPlayerIfTargetSingle()
    
        guard let targetPlayerUnwrapped = targetPlayerWrapped else {
            return
        }

        guard let card = targetPlayerUnwrapped.getCard(where: cardPredicate) else {
            return
        }

        gameRunner.executeGameEvents([
            MoveCardPlayerToPlayerEvent(card: card, fromPlayer: targetPlayerUnwrapped, toPlayer: args.player)
        ])
    }
}
