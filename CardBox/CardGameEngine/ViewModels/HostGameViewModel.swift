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
    private var hostGameManager: HostGameManager?
    var gameRunner: GameRunnerProtocol?

    var gameStarted: Bool {
        guard let gameRunner = gameRunner, hostGameManager != nil else {
            return false
        }
        return gameRunner.gameState.state == .start
    }

    var isRoomFull: Bool {
        players.count == 4
    }

    init() {
    }

    func loadDatabaseManager(_ databaseManager: DatabaseManager) {
        databaseManager.addObserver(self)
        self.hostGameManager = databaseManager
    }

    func createRoom(playerViewModel: PlayerViewModel) {
        guard let hostGameManager = hostGameManager else {
            return
        }
        hostGameManager.createRoom(player: playerViewModel.player)
    }

    func removeFromRoom(playerViewModel: PlayerViewModel) {
        guard let hostGameManager = hostGameManager else {
            return
        }
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

    func notifyObserver(gameRunner: GameRunnerProtocol) {
        self.gameRunner = gameRunner
    }

    func startGame() {
        guard let hostGameManager = hostGameManager else {
            return
        }
        hostGameManager.startGame()
    }

    func notifyObserver(playerIndex: Int) {
        self.playerIndex = playerIndex
    }
}
