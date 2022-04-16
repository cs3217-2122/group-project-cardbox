//
//  MonopolyDealGameRunnerObserver.swift
//  CardBox
//
//  Created by Stuart Long on 15/4/22.
//

protocol MonopolyDealGameRunnerObserver {
    func notifyObserver(_ monopolyDealGameState: MonopolyDealGameState, _ gameEvents: [GameEvent])
}
