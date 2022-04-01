//
//  HostGameViewModel.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//
import SwiftUI

class HostGameViewModel: ObservableObject, DatabaseManagerObserver {

    @Published var gameRoomID: String = ""
    @Published var players: [String] = []
    private var hostGameManager: HostGameManager

    init() {
        self.hostGameManager = DatabaseManager()
        self.hostGameManager.addObserver(self)
    }

    func createRoom(playerViewModel: PlayerViewModel) {
        hostGameManager.createRoom(player: playerViewModel.player)
    }

    func removeFromRoom(playerViewModel: PlayerViewModel) {
        hostGameManager.removeFromRoom(player: playerViewModel.player)
    }

    func notifyObserver(gameRoomID: String) {
        self.gameRoomID = gameRoomID
    }

    func notifyObserver(players: [String]) {
        self.players = players
    }

    func notifyObserver(isJoined: Bool) {

    }
}
