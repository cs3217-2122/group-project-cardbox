//
//  ShuffleDeckEvent.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct ShuffleDeckEvent: GameEvent {
    let deck: CardCollection

    func updateRunner(gameRunner: GameRunnerProtocol) {
        deck.shuffle()
    }
}
