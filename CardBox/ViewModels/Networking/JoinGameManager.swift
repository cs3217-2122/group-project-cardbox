//
//  JoinGameManager.swift
//  CardBox
//
//  Created by Stuart Long on 2/4/22.
//

protocol JoinGameManager {
    var isJoined: Bool { get }
    var players: [String] { get }
    var gameRoomID: String { get }

    func joinRoom(id: String, player: Player)
    func removeFromRoom(player: Player)
    func addObserver(_ databaseManagerObserver: DatabaseManagerObserver)
}
