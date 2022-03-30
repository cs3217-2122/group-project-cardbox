//
//  JoinGameViewModel.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//
import Firebase
import SwiftUI

class JoinGameViewModel: ObservableObject {

    @Published var isJoined = false
    @Published var players: [String] = []
    @Published var joinedRoomID: String = ""
    private let db = Firestore.firestore()

    func joinRoom(id: String) {
        // query database to see if this room exists, if does not, alert user
        let docRef = db.collection("rooms").document(id)

        docRef.getDocument { document, _ in
            guard let document = document, document.exists else {
                // TODO: find a way to alert
                self.notJoined()
                print("document does not exist/ error occurred")
                return
            }

            print("exists")
            let uniqueUserID = UIDevice.current.identifierForVendor?.uuidString
            var players = document["players"] as? [String] ?? []

            if let uniqueUserID = uniqueUserID {
                print(uniqueUserID)
                players.append(uniqueUserID)
                docRef.setData(["players": players], merge: true)
            }

            self.joined(id: id, players: players)
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
