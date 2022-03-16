//
//  PlayerInsertCardIntoDeckCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct PlayerInsertCardIntoDeckCardAction: CardAction {
    let card: Card
    let offsetFromTop: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly, player: Player, target: GameplayTarget) {
        gameRunner.executeGameEvents(
            [MoveCardPlayerToDeckEvent(card: card, player: player, offsetFromTop: offsetFromTop)]
        )
    }
}
