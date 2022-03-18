//
//  PlayerTakesNthCardFromPlayerCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/3/22.
//

struct PlayerTakesNthCardFromPlayerCardAction: CardAction {

    enum StateOfN {
        case random
        case given
    }

    let n: Int
    let stateOfN: StateOfN

    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {

        let targetPlayerWrapped = args.target.getPlayerIfTargetSingle()

        guard let targetPlayerUnwrapped = targetPlayerWrapped else {
            return
        }

        let computedN = getN(targetPlayer: targetPlayerUnwrapped)

        guard let card = targetPlayerUnwrapped.getCardByIndex(computedN) else {
            return
        }

        gameRunner.executeGameEvents([
            MoveCardPlayerToPlayerEvent(card: card, fromPlayer: args.player, toPlayer: targetPlayerUnwrapped)
        ])
    }

    private func getN(targetPlayer: Player) -> Int {
        if stateOfN == .given {
            return n
        } else if stateOfN == .random {
            return Int.random(in: 0 ..< targetPlayer.hand.count)
        } else {
            assert(false, "Unidentified state of n in PlayerTakesNthCardFromPlayerCardAction")
            return -1
        }
    }
}
