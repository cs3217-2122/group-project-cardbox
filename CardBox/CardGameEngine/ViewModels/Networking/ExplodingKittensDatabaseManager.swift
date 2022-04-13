//
//  ExplodingKittensDatabaseManager.swift
//  CardBox
//
//  Created by Stuart Long on 4/4/22.
//
import Firebase
import FirebaseFirestoreSwift

class ExplodingKittensDatabaseManager: DatabaseManager, ExplodingKittensGameRunnerObserver {

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

    internal var gameRunner: GameRunnerProtocol? {
        didSet {
            guard let gameRunner = gameRunner as? ExplodingKittensGameRunner else {
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

    internal var observers: [DatabaseManagerObserver] = []
    internal var db = Firestore.firestore()

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

        if !gameRoomID.isEmpty {
            print("retrieving data before log")
            var fromFirestore: ExplodingKittensFirebaseAdapter?

            db.collection("rooms").document(gameRoomID).getDocument { doc, _ in
                if let doc = doc {
                    print("decoding data")
                    fromFirestore = self.decodeExplodingKittensFirebaseAdapter(doc)
                }
            }

            if let fromFirestore = fromFirestore {
                print("decoded successfully")
                for log in fromFirestore.log.logs {
                    print(log.type)
                }
                explodingKittensFirebaseAdapter.log.appendToFront(fromFirestore.log.logs)
            } else {
                print("did not decode")
            }
        }

        do {
            try docRef.setData(from: explodingKittensFirebaseAdapter)
        } catch {
            print(error)
        }
    }

    private func retrieveUpdates(_ document: DocumentSnapshot) {
        if let explodingKittensFirebaseAdapter = decodeExplodingKittensFirebaseAdapter(document) {
            self.players = explodingKittensFirebaseAdapter.players.names
            guard let gameRunner = gameRunner as? ExplodingKittensGameRunner else {
                return
            }

//            if gameRunner.state == .start {
//                gameRunner.updateState(explodingKittensFirebaseAdapter.toGameRunner(observer: self))
//            } else {
//                gameRunner.updateStateMutable(explodingKittensFirebaseAdapter.toGameRunner(observer: self))
//            }
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

    func notifyObserver(_ explodingKittensGameRunner: ExplodingKittensGameRunner, _ gameEvents: [GameEvent]) {
        let docRef = db.collection("rooms").document(gameRoomID)

        let toEncode = ExplodingKittensFirebaseAdapter(explodingKittensGameRunner: explodingKittensGameRunner)

        toEncode.log.append(gameEvents)

        encodeExplodingKittensFirebaseAdapter(toEncode,
                                              docRef)
    }

    func startGame() {
        guard let gameRunner = gameRunner as? ExplodingKittensGameRunner else {
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