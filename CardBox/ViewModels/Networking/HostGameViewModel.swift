//
//  HostGameViewModel.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//
import Firebase
import FirebaseFirestoreSwift
import SwiftUI

class HostGameViewModel: ObservableObject {

    @Published var gameRoomID: String = ""
    @Published var players: [String] = []
    private let db = Firestore.firestore()

    func createRoom(playerViewModel: PlayerViewModel) {
        var docRef: DocumentReference?
        let player = playerViewModel.player

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
        }
    }

    func removeFromRoom(playerViewModel: PlayerViewModel) {
        print(gameRoomID)
        print(gameRoomID.isEmpty)
        let docRef = db.collection("rooms").document(gameRoomID)
        let player = playerViewModel.player

        docRef.getDocument { document, _ in
            guard let document = document, document.exists else {
                // TODO: find a way to alert
                self.gameRoomID = ""
                print("document does not exist/ error occurred")
                return
            }

            do {
                let explodingKittensFirebaseAdapter = try document.data(as: ExplodingKittensFirebaseAdapter.self)
                explodingKittensFirebaseAdapter.players.remove(player)
                try docRef.setData(from: explodingKittensFirebaseAdapter)
                print(explodingKittensFirebaseAdapter.players)
                self.gameRoomID = ""
            } catch {
                print(error)
            }
        }
    }
}
