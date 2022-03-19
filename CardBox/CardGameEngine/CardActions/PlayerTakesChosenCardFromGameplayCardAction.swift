//
//  PlayerTakesChosenCardFromGameplayCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 19/3/22.
//

struct PlayerTakesChosenCardFromGameplayCardAction: CardAction {

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        guard let card = args.card else {
            return
        }
        gameRunner.executeGameEvents([MoveCardGameplayToPlayerEvent(card: card, player: args.player)])
    }
}
