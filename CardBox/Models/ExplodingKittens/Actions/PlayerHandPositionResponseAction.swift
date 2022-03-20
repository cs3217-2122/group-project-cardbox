//
//  PlayerHandPositionResponseAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 19/3/22.
//

struct PlayerHandPositionResponseAction: Action {
    let target: Player
    let player: Player
    let playerHandPosition: Int

    func executeGameEvents(gameRunner: GameRunnerReadOnly) {
        PlayerTakesNthCardFromPlayerCardAction(n: playerHandPosition, stateOfN: .given)
            .executeGameEvents(gameRunner: gameRunner,
                               args: CardActionArgs(card: nil,
                                                    player: player,
                                                    target: .single(target)))
    }
}
