//
//  DatabaseManagerObserver.swift
//  CardBox
//
//  Created by Stuart Long on 2/4/22.
//

protocol DatabaseManagerObserver {
    func notifyObserver(isJoined: Bool)
    func notifyObserver(players: [String])
    func notifyObserver(gameRoomID: String)
    func notifyObserver(gameRunner: GameRunnerProtocol)
    func notifyObserver(playerIndex: Int)
}
