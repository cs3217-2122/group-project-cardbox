//
//  DeckPositionRequestCardAction.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

struct DeckPositionRequestCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {

        guard let card = args.card else {
            // TODO: Exception
            return
        }

        gameRunner.executeGameEvents([
            DeckPositionRequestEvent(card: card, player: args.player)
        ])
    }
}
