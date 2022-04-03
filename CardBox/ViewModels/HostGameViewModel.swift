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
    var playerIndex: Int?
    private var hostGameManager: HostGameManager
    var gameRunner: ExplodingKittensGameRunner?

    var gameStarted: Bool {
        guard let gameRunner = gameRunner else {
            return false
        }
        return gameRunner.state == .start
    }

    var isRoomFull: Bool {
        players.count == 4
    }

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
        // do nothing
    }

    func notifyObserver(gameRunner: ExplodingKittensGameRunner) {
        self.gameRunner = gameRunner
    }

    func startGame() {
        // TODO: Implement start game
        hostGameManager.startGame()
    }

    func notifyObserver(playerIndex: Int) {
        self.playerIndex = playerIndex
    }
}
