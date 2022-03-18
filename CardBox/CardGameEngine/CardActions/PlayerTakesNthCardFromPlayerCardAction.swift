//
//  PlayerTakesNthCardFromPlayerCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/3/22.
//

struct PlayerTakesNthCardFromPlayerCardAction: CardAction {
    let n: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        let targetPlayerWrapped = getPlayerIfTargetSingle(target: args.target)

        guard let targetPlayerUnwrapped = targetPlayerWrapped else {
            return
        }

        guard let card = targetPlayerUnwrapped.getCardByIndex(n) else {
            return
        }

        gameRunner.executeGameEvents([
            MoveCardPlayerToPlayerEvent(card: card, fromPlayer: args.player, toPlayer: targetPlayerUnwrapped)
        ])
    }

    private func getPlayerIfTargetSingle(target: GameplayTarget) -> Player? {
        switch target {
        case let .single(targetPlayer):
            return targetPlayer
        case .all, .none:
            return nil
        }
    }
}
