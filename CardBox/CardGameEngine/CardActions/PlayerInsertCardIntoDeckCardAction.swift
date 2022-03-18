//
//  PlayerInsertCardIntoDeckCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct PlayerInsertCardIntoDeckCardAction: CardAction {
    let card: Card
    let offsetFromTop: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        gameRunner.executeGameEvents(
            [MoveCardPlayerToDeckEvent(card: card, player: args.player, offsetFromTop: offsetFromTop)]
        )
    }
}
