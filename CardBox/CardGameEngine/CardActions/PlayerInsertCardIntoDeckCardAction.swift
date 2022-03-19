//
//  PlayerInsertCardIntoDeckCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct PlayerInsertCardIntoDeckCardAction: CardAction {
    let offsetFromTop: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        guard let card = args.card else {
            return
        }

        gameRunner.executeGameEvents(
            [MoveCardPlayerToDeckEvent(card: card, player: args.player, offsetFromTop: offsetFromTop)]
        )
    }
}
