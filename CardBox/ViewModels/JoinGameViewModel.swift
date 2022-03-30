//
//  JoinGameViewModel.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//
import Firebase

class JoinGameViewModel: ObservableObject {

    @Published var isJoined = false
    @Published var players: [String] = []
    @Published var joinedRoomID: String = ""
    private let db = Firestore.firestore()

    func joinRoom(id: String) {
        // query database to see if this room exists, if does not, alert user
        let docRef = db.collection("rooms").document(id)

        docRef.getDocument { document, error in
            if let error = error {
                print(error)
                self.notJoined()
                return
            }

            if let document = document, document.exists {
                print("exists")
                self.joined(id: id, players: document["players"] as? [String] ?? [])
            } else {
                // TODO: find a way to alert user
                self.isJoined = false
                print("document does not exist")
            }
        }
    }

    private func notJoined() {
        self.isJoined = false
        self.players = []
        self.joinedRoomID = ""
    }

    private func joined(id: String, players: [String]) {
        self.isJoined = true
        print(players)
        self.players = players
        self.joinedRoomID = id
    }
}
