//
//  PlayerTakesChosenCardFromGameplayCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 19/3/22.
//

struct PlayerTakesChosenCardFromGameplayCardAction: CardAction {

    let cardPredicate: (Card) -> Bool

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        guard let card = gameRunner.gameplayArea.getCard(where: cardPredicate) else {
            return
        }
        gameRunner.executeGameEvents([MoveCardGameplayToPlayerEvent(card: card, player: args.player)])
    }
}
