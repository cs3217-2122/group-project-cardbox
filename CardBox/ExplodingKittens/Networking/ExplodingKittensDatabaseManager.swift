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

    private func decodeGameState(_ document: DocumentSnapshot) -> ExplodingKittensGameState? {
        do {
            let explodingKittensGameState = try document.data(as: ExplodingKittensGameState.self)
            print("decoded")
            return explodingKittensGameState
        } catch {
            print(error)
            return nil
        }
    }

    private func encodeGameState(_ gameState: ExplodingKittensGameState, _ docRef: DocumentReference) {
        do {
            try docRef.setData(from: gameState)
        } catch {
            print(error)
        }
    }

    private func retrieveUpdates(_ document: DocumentSnapshot) {
        if let gameState = decodeGameState(document), let gameRunner = gameRunner {
            self.players = gameState.players.names
            print("gamestate after decoding: \(gameState.playerHands)")
            gameRunner.updateState(gameState: gameState)
            print("gamestate after updatestate: \(gameRunner.gameState.playerHands)")
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
                self.notJoined()
                return
            }

            let gameState = self.decodeGameState(document)

            guard let gameState = gameState else {
                return
            }

            // check if full
            if gameState.players.count == 4 {
                // TODO: find a way to alert
                self.notJoined()
            } else {
                // add to room
                gameState.players
                    .addPlayer(ExplodingKittensPlayer(name: player.name,
                                                      id: player.id,
                                                      isOutOfGame: player.isOutOfGame,
                                                      cardsPlayed: player.cardsPlayed))
                gameState.addPlayerHand(playerId: player.id, cards: CardCollection())
                self.encodeGameState(gameState, docRef)
                self.joined(id: id,
                            gameRunner: ExplodingKittensGameRunner(gameState: gameState, observer: self))
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

    private func joined(id: String, gameRunner: ExplodingKittensGameRunner) {
        self.isJoined = true
        self.players = gameRunner.gameState.players.names
        self.gameRoomID = id
        self.gameRunner = gameRunner
        self.playerIndex = gameRunner.gameState.players.count - 1
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
            if let gameState = self.decodeGameState(document) {
                gameState.players.remove(player)
                self.encodeGameState(gameState, docRef)
                self.notJoined()
            }
        }
    }

    func createRoom(player: Player) {
        var docRef: DocumentReference?

        let explodingKittensGameRunner = ExplodingKittensGameRunner(host: player, observer: self)

        guard let gameState = explodingKittensGameRunner.gameState as? ExplodingKittensGameState else {
            return
        }

        docRef = db.collection("rooms").document()

        if let docRef = docRef {
            self.encodeGameState(gameState, docRef)
            self.joined(id: docRef.documentID,
                        gameRunner: explodingKittensGameRunner)

            print("adding listener now")

            self.addListener(docRef)
        }
    }

    func notifyObserver(_ explodingKittensGameState: ExplodingKittensGameState, _ gameEvents: [GameEvent]) {
        let docRef = db.collection("rooms").document(gameRoomID)

        encodeGameState(explodingKittensGameState, docRef)
    }

    func startGame() {
        guard let gameRunner = gameRunner as? ExplodingKittensGameRunner else {
            return
        }

        guard let gameState = gameRunner.gameState as? ExplodingKittensGameState else {
            return
        }
        let docRef = db.collection("rooms").document(gameRoomID)

        gameRunner.setup()
        gameRunner.gameState.state = .start

        encodeGameState(gameState, docRef)
    }
}
