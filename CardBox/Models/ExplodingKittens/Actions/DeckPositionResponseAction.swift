//
//  DeckPositionResponseAction.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

struct DeckPositionResponseAction: Action {
    let card: Card
    let player: Player
    let offsetFromTop: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        gameRunner.executeGameEvents(
            [MoveCardPlayerToDeckEvent(card: card, player: player, offsetFromTop: offsetFromTop)]
        )
    }
}
