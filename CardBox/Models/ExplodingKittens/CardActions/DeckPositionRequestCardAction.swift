//
//  DeckPositionRequestCardAction.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

struct DeckPositionRequestCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, card: Card, player: Player, target: GameplayTarget) {
        gameRunner.executeGameEvents([
            DeckPositionRequestEvent(card: card)
        ])
    }
}
