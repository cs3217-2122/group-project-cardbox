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
                return
            }

            var players = document["players"] as? [String] ?? []

            // check if full
            if players.count == 4 {
                // find a way to alert
                print("room is full")
                self.notJoined()
            } else {
                // add to room
                let uniqueUserID = UIDevice.current.identifierForVendor?.uuidString

                if let uniqueUserID = uniqueUserID {
                    print(uniqueUserID)
                    players.append(uniqueUserID)
                    docRef.setData(["players": players], merge: true)
                }

                self.joined(id: id, players: players)
                docRef.addSnapshotListener { documentSnapshot, _ in
                    guard let document = documentSnapshot else {
                        return
                    }
                    self.players = document["players"] as? [String] ?? []
                    print(self.players)
                }
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

    func removeFromRoom() {
        print(joinedRoomID)
        let docRef = db.collection("rooms").document(joinedRoomID)

        docRef.getDocument { document, _ in
            guard let document = document, document.exists else {
                // TODO: find a way to alert
                self.notJoined()
                print("document does not exist/ error occurred")
                return
            }

            var players = document["players"] as? [String] ?? []
            let uniqueUserID = UIDevice.current.identifierForVendor?.uuidString
            if let uniqueUserID = uniqueUserID {
                if let index = players.firstIndex(of: uniqueUserID) {
                    players.remove(at: index)
                }
                docRef.setData(["players": players], merge: true)
                self.notJoined()
            }
        }
    }
}
