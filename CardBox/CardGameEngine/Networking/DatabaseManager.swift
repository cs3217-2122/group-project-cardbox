//
//  DatabaseManager.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//
import Firebase
import FirebaseFirestoreSwift

// This class is used to propogate changes of the gamestate to the realtime database.
// This class is in charge of the joining and hosting of rooms,
// as well as updating the server when gamestate changes.
protocol DatabaseManager: JoinGameManager, HostGameManager {

    var isJoined: Bool { get }
    var players: [String] { get }
    var gameRoomID: String { get }
    var gameRunner: GameRunnerProtocol? { get }
    var playerIndex: Int? { get }
    var observers: [DatabaseManagerObserver] { get }
    var db: Firestore { get }

    func addObserver(_ databaseManagerObserver: DatabaseManagerObserver)
    func joinRoom(id: String, player: Player)
    func removeFromRoom(player: Player)
    func createRoom(player: Player)
    func startGame()
    func encodeGameState(_ gameState: GameState, _ docRef: DocumentReference)
    func decodeGameState(_ document: DocumentSnapshot) -> GameState?
}
