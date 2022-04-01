//
//  HostGameManager.swift
//  CardBox
//
//  Created by Stuart Long on 2/4/22.
//

protocol HostGameManager {
    var isJoined: Bool { get }
    var players: [String] { get }
    var gameRoomID: String { get }

    func createRoom(player: Player)
    func removeFromRoom(player: Player)

    func addObserver(_ databaseManagerObserver: DatabaseManagerObserver)
}
