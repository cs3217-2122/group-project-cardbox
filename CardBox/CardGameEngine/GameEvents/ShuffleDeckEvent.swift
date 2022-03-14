//
//  ShuffleDeckEvent.swift
//  CardBox
//
//  Created by mactest on 11/03/2022.
//

struct ShuffleDeckEvent: GameEvent {
    func updateRunner(gameRunner: GameRunner) {
        gameRunner.deck.shuffle()
    }
}
