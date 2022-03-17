//
//  ShuffleDeckCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct ShuffleDeckCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, card: Card, player: Player, target: GameplayTarget) {
        ShuffleDeckAction().executeGameEvents(gameRunner: gameRunner)
    }
}
