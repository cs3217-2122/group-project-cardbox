//
//  ExplodingKittensGameRunnerObserver.swift
//  CardBox
//
//  Created by Stuart Long on 2/4/22.
//

protocol ExplodingKittensGameRunnerObserver {
    func notifyObserver(_ explodingKittensGameState: ExplodingKittensGameState, _ gameEvents: [GameEvent])
}
