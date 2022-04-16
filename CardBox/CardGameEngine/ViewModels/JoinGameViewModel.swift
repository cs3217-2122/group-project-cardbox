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
    var playerIndex: Int?
    private var joinGameManager: JoinGameManager?
    var gameRunner: GameRunnerProtocol?

    var gameStarted: Bool {
        guard let gameRunner = gameRunner, joinGameManager != nil else {
            return false
        }
        return gameRunner.gameState.state == .start
    }

    init() {
    }

    func loadDatabaseManager(_ databaseManager: DatabaseManager) {
        databaseManager.addObserver(self)
        self.joinGameManager = databaseManager
    }

    func joinRoom(id: String, playerViewModel: PlayerViewModel) {
        guard let joinGameManager = joinGameManager else {
            return
        }
        joinGameManager.joinRoom(id: id, player: playerViewModel.player)
    }

    func removeFromRoom(playerViewModel: PlayerViewModel) {
        guard let joinGameManager = joinGameManager else {
            return
        }

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

    func notifyObserver(gameRunner: GameRunnerProtocol) {
        self.gameRunner = gameRunner
    }

    func notifyObserver(playerIndex: Int) {
        self.playerIndex = playerIndex
    }
}
