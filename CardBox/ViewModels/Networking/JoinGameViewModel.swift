//
//  JoinGameViewModel.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class JoinGameViewModel: ObservableObject {

    @Published var isJoined = false
    @Published var players: [String] = []
    @Published var joinedRoomID: String = ""
    private let db = Firestore.firestore()

    func joinRoom(id: String, playerViewModel: PlayerViewModel) {
        // query database to see if this room exists, if does not, alert user
        let docRef = db.collection("rooms").document(id)
        let player = playerViewModel.player

        docRef.getDocument { document, _ in
            guard let document = document, document.exists else {
                // TODO: find a way to alert
                print("not exist")
                self.notJoined()
                return
            }

            var explodingKittensFirebaseAdapter: ExplodingKittensFirebaseAdapter?
            do {
                explodingKittensFirebaseAdapter = try document.data(as: ExplodingKittensFirebaseAdapter.self)
            } catch {
                print(error)
            }

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
                do {
                    try docRef.setData(from: explodingKittensFirebaseAdapter)
                } catch {
                    print(error)
                }

                self.joined(id: id, players: explodingKittensFirebaseAdapter.players)

                docRef.addSnapshotListener { documentSnapshot, _ in
                    guard let document = documentSnapshot else {
                        return
                    }
                    do {
                        let explodingKittensFirebaseAdapter = try document
                            .data(as: ExplodingKittensFirebaseAdapter.self)
                        self.players = explodingKittensFirebaseAdapter.players.names
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }

    private func notJoined() {
        self.isJoined = false
        self.players = []
        self.joinedRoomID = ""
    }

    private func joined(id: String, players: PlayerCollection) {
        self.isJoined = true
        print(players)
        self.players = players.names
        self.joinedRoomID = id
    }

    func removeFromRoom(playerViewModel: PlayerViewModel) {
        let player = playerViewModel.player
        print(joinedRoomID)
        let docRef = db.collection("rooms").document(joinedRoomID)

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
        }
    }
}
