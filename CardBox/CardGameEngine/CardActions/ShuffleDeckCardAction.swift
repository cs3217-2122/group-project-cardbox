//
//  ShuffleDeckCardAction.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/3/22.
//

struct ShuffleDeckCardAction: CardAction {
    func executeGameEvents(gameRunner: GameRunnerReadOnly, args: CardActionArgs) {
        ShuffleDeckAction().executeGameEvents(gameRunner: gameRunner)
    }
}
