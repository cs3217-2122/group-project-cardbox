//
//  JoinGameViewModel.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//
import SwiftUI

class JoinGameViewModel: ObservableObject, DatabaseManagerObserver {

    @Published var isJoined = false
    @Published var players: [String] = []
    @Published var gameRoomID: String = ""
    private var joinGameManager: JoinGameManager

    init() {
        self.joinGameManager = DatabaseManager()
        self.joinGameManager.addObserver(self)
    }

    func joinRoom(id: String, playerViewModel: PlayerViewModel) {
        joinGameManager.joinRoom(id: id, player: playerViewModel.player)
    }

    func removeFromRoom(playerViewModel: PlayerViewModel) {
        joinGameManager.removeFromRoom(player: playerViewModel.player)
    }

    func notifyObserver(isJoined: Bool) {
        self.isJoined = isJoined
    }

    func notifyObserver(players: [String]) {
        self.players = players
    }

    func notifyObserver(gameRoomID: String) {
        self.gameRoomID = gameRoomID
    }
}
