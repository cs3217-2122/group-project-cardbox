//
//  PlayerHandPositionRequestCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 19/3/22.
//

struct PlayerHandPositionRequestCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {

        guard let card = args.card else {
            // TODO: Exception
            return
        }

        gameRunner.executeGameEvents([
            PlayerHandPositionRequestEvent(target: args.target, player: args.player)
        ])
    }
}
