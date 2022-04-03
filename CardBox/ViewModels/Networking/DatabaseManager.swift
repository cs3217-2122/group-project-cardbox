//
//  DatabaseManager.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

// This class is used to propogate changes of the gamestate to the realtime database.
// This class is in charge of the joining and hosting of rooms,
// as well as updating the server when gamestate changes.
class DatabaseManager: JoinGameManager, HostGameManager, ExplodingKittensGameRunnerObserver {

    internal var isJoined = false {
        didSet {
            notifyObservers(isJoined: isJoined)
        }
    }

    internal var players: [String] = [] {
        didSet {
            notifyObservers(players: players)
        }
    }

    internal var gameRoomID: String = "" {
        didSet {
            notifyObservers(gameRoomID: gameRoomID)
        }
    }

    internal var gameRunner: ExplodingKittensGameRunner? {
        didSet {
            guard let gameRunner = gameRunner else {
                return
            }

            notifyObservers(gameRunner: gameRunner)
        }
    }

    internal var playerIndex: Int? {
        didSet {
            guard let playerIndex = playerIndex else {
                return
            }

            notifyObservers(playerIndex: playerIndex)
        }
    }

    private var observers: [DatabaseManagerObserver] = []
    private let db = Firestore.firestore()

    func addObserver(_ databaseManagerObserver: DatabaseManagerObserver) {
        self.observers.append(databaseManagerObserver)
    }

    private func notifyObservers(gameRoomID: String) {
        for observer in observers {
            observer.notifyObserver(gameRoomID: gameRoomID)
        }
    }

    private func notifyObservers(playerIndex: Int) {
        for observer in observers {
            observer.notifyObserver(playerIndex: playerIndex)
        }
    }

    private func notifyObservers(gameRunner: ExplodingKittensGameRunner) {
        for observer in observers {
            observer.notifyObserver(gameRunner: gameRunner)
        }
    }

    private func notifyObservers(isJoined: Bool) {
        for observer in observers {
            observer.notifyObserver(isJoined: isJoined)
        }
    }

    private func notifyObservers(players: [String]) {
        for observer in observers {
            observer.notifyObserver(players: players)
        }
    }

    private func decodeExplodingKittensFirebaseAdapter(
        _ document: DocumentSnapshot) -> ExplodingKittensFirebaseAdapter? {
        do {
            let explodingKittensFirebaseAdapter = try document.data(as: ExplodingKittensFirebaseAdapter.self)
            return explodingKittensFirebaseAdapter
        } catch {
            print(error)
            return nil
        }
    }

    private func encodeExplodingKittensFirebaseAdapter(
        _ explodingKittensFirebaseAdapter: ExplodingKittensFirebaseAdapter,
        _ docRef: DocumentReference) {
        do {
            try docRef.setData(from: explodingKittensFirebaseAdapter)
        } catch {
            print(error)
        }
    }

    private func retrieveUpdates(_ document: DocumentSnapshot) {
        if let explodingKittensFirebaseAdapter = decodeExplodingKittensFirebaseAdapter(document) {
            self.players = explodingKittensFirebaseAdapter.players.names
            for player in players {
                print(player)
            }

            guard let gameRunner = gameRunner else {
                return
            }

            gameRunner.updateState(explodingKittensFirebaseAdapter.toGameRunner(observer: self))
        }
    }

    private func addListener(_ docRef: DocumentReference) {
        docRef.addSnapshotListener { documentSnapshot, _ in
            guard let document = documentSnapshot else {
                return
            }
            self.retrieveUpdates(document)
        }
    }

    func joinRoom(id: String, player: Player) {
        // query database to see if this room exists, if does not, alert user
        let docRef = db.collection("rooms").document(id)

        docRef.getDocument { document, _ in
            guard let document = document, document.exists else {
                // TODO: find a way to alert
//                print("not exist")
                self.notJoined()
                return
            }

            let explodingKittensFirebaseAdapter = self.decodeExplodingKittensFirebaseAdapter(document)

            guard let explodingKittensFirebaseAdapter = explodingKittensFirebaseAdapter else {
                return
            }
            // check if full
            if explodingKittensFirebaseAdapter.players.count == 4 {
                // find a way to alert
//                print("room is full")
                self.notJoined()
            } else {
                // add to room
                explodingKittensFirebaseAdapter.players
                    .addPlayer(ExplodingKittensPlayer(name: player.name,
                                                      id: player.id,
                                                      isOutOfGame: player.isOutOfGame,
                                                      cardsPlayed: player.cardsPlayed))
                explodingKittensFirebaseAdapter.playerHands
                    .append(ExplodingKittensCardCollectionAdapter(CardCollection()))
                self.encodeExplodingKittensFirebaseAdapter(explodingKittensFirebaseAdapter, docRef)
                self.joined(id: id,
                            gameRunnerAdapter: explodingKittensFirebaseAdapter)
                self.addListener(docRef)
            }
        }
    }

    private func notJoined() {
        self.isJoined = false
        self.players = []
        self.gameRoomID = ""
        self.playerIndex = nil
    }

    private func joined(id: String, gameRunnerAdapter: ExplodingKittensFirebaseAdapter) {
        self.isJoined = true
        print(players)
        self.players = gameRunnerAdapter.players.names
        self.gameRoomID = id
        self.gameRunner = gameRunnerAdapter.toGameRunner(observer: self)
        self.playerIndex = gameRunnerAdapter.players.count - 1
    }

    func removeFromRoom(player: Player) {
        print(gameRoomID)
        let docRef = db.collection("rooms").document(gameRoomID)

        docRef.getDocument { document, _ in
            guard let document = document, document.exists else {
                // TODO: find a way to alert
                self.notJoined()
                print("document does not exist/ error occurred")
                return
            }
            if let explodingKittensFirebaseAdapter = self.decodeExplodingKittensFirebaseAdapter(document) {
                explodingKittensFirebaseAdapter.players.remove(player)
                self.encodeExplodingKittensFirebaseAdapter(
                    explodingKittensFirebaseAdapter,
                    docRef)
                self.notJoined()
            }
        }
    }

    func createRoom(player: Player) {
        var docRef: DocumentReference?

        // TODO: this only allows exploding kitten, allow customisation to choose games
        let explodingKittensGameRunner = ExplodingKittensGameRunner(host: player, observer: self)

        let explodingKittensFirebaseAdapter = ExplodingKittensFirebaseAdapter(
            explodingKittensGameRunner: explodingKittensGameRunner)

        docRef = db.collection("rooms").document()

        if let docRef = docRef {
            self.encodeExplodingKittensFirebaseAdapter(explodingKittensFirebaseAdapter,
                                                       docRef)
            self.joined(id: docRef.documentID,
                        gameRunnerAdapter: explodingKittensFirebaseAdapter)

            print("adding listener now")

            self.addListener(docRef)
        }
    }

    func notifyObserver(_ explodingKittensGameRunner: ExplodingKittensGameRunner) {
        let docRef = db.collection("rooms").document(gameRoomID)

        encodeExplodingKittensFirebaseAdapter(
            ExplodingKittensFirebaseAdapter(explodingKittensGameRunner: explodingKittensGameRunner),
            docRef)
    }

    func startGame() {
        guard let gameRunner = gameRunner else {
            return
        }

        let docRef = db.collection("rooms").document(gameRoomID)

        gameRunner.setup()
        gameRunner.state = .start

        encodeExplodingKittensFirebaseAdapter(
            ExplodingKittensFirebaseAdapter(explodingKittensGameRunner: gameRunner),
            docRef)
    }
}
