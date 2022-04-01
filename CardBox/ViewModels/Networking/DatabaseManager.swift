//
//  DatabaseManager.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class DatabaseManager: JoinGameManager, HostGameManager {
    // This class is used to propogate changes of the gamestate to the realtime database
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
    private var observers: [DatabaseManagerObserver] = []
    private let db = Firestore.firestore()

    func addObserver(_ databaseManagerObserver: DatabaseManagerObserver) {
        self.observers.append(databaseManagerObserver)
    }

//    private func notifyObservers() {
//        for observer in observers {
//            observer.notifyObserver(isJoined: isJoined, players: players, gameRoomID: gameRoomID)
//        }
//    }

    private func notifyObservers(gameRoomID: String) {
        for observer in observers {
            observer.notifyObserver(gameRoomID: gameRoomID)
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
        do {
            let explodingKittensFirebaseAdapter = try document
                .data(as: ExplodingKittensFirebaseAdapter.self)
            self.players = explodingKittensFirebaseAdapter.players.names
//            self.notifyObservers()
        } catch {
            print(error)
        }
    }

    func joinRoom(id: String, player: Player) {
        // query database to see if this room exists, if does not, alert user
        let docRef = db.collection("rooms").document(id)

        docRef.getDocument { document, _ in
            guard let document = document, document.exists else {
                // TODO: find a way to alert
                print("not exist")
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
                print("room is full")
                self.notJoined()
            } else {
                // add to room
                explodingKittensFirebaseAdapter.players.addPlayer(player)
                self.encodeExplodingKittensFirebaseAdapter(explodingKittensFirebaseAdapter, docRef)

                self.joined(id: id, players: explodingKittensFirebaseAdapter.players)

                docRef.addSnapshotListener { documentSnapshot, _ in
                    guard let document = documentSnapshot else {
                        return
                    }
                    self.retrieveUpdates(document)
                }
            }

//            self.notifyObservers()
        }

    }

    private func notJoined() {
        self.isJoined = false
        self.players = []
        self.gameRoomID = ""
    }

    private func joined(id: String, players: PlayerCollectionAdapter) {
        self.isJoined = true
        print(players)
        self.players = players.names
        self.gameRoomID = id
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
            do {
                let explodingKittensFirebaseAdapter = try document.data(as: ExplodingKittensFirebaseAdapter.self)
                explodingKittensFirebaseAdapter.players.remove(player)
                try docRef.setData(from: explodingKittensFirebaseAdapter)
                self.notJoined()
            } catch {
                print(error)
            }

//            self.notifyObservers()
        }
    }

    func createRoom(player: Player) {
        var docRef: DocumentReference?

        // TODO: this only allows exploding kitten, allow customisation to choose games
        let explodingKittensGameRunner = ExplodingKittensGameRunner(host: player)

        let explodingKittensFirebaseAdapter = ExplodingKittensFirebaseAdapter(
            explodingKittensGameRunner: explodingKittensGameRunner)

        docRef = db.collection("rooms").document()

        if let docRef = docRef {
            do {
                try docRef.setData(from: explodingKittensFirebaseAdapter) { error in
                    if error != nil {
                        print("error creating room")
                        return
                    } else {
                        print("room created with unique ID \(docRef.documentID)")
                        self.gameRoomID = docRef.documentID
                        print(self.gameRoomID)
                        self.players = [player.name]
                        print(self.players)
                    }
                }
            } catch {
                print(error)
            }

            print("adding listener now")

            docRef.addSnapshotListener { documentSnapshot, _ in
                guard let document = documentSnapshot else {
                    return
                }
                do {
                    let explodingKittensFirebaseAdapter = try document.data(as: ExplodingKittensFirebaseAdapter.self)
                    self.players = explodingKittensFirebaseAdapter.players.names
                } catch {
                    print(error)
                }
            }

//            self.notifyObservers()
        }

    }
}
