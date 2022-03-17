//
//  DeckPositionRequestCardAction.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

struct DeckPositionRequestCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        gameRunner.executeGameEvents([
            DeckPositionRequestEvent(card: args.card)
        ])
    }
}
