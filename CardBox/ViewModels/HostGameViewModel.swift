//
//  HostGameViewModel.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//
import Firebase
import SwiftUI

class HostGameViewModel: ObservableObject {

    @Published var gameRoomID: String = ""
    private let db = Firestore.firestore()

    func createRoom() {
        var docRef: DocumentReference?
        let uniqueUserID = UIDevice.current.identifierForVendor?.uuidString

        if let uniqueUserID = uniqueUserID {
            docRef = db.collection("rooms").addDocument(data: ["players": [uniqueUserID]]) { error in
                if error != nil {
                    print("error creating room")
                    return
                } else {
                    guard let docRef = docRef else {
                        return
                    }

                    print("room created with unique ID \(docRef.documentID)")
                    self.gameRoomID = docRef.documentID
                }
            }
        }
    }

    func removeFromRoom() {
        print(gameRoomID)
        print(gameRoomID.isEmpty)
        let docRef = db.collection("rooms").document(gameRoomID)

        docRef.getDocument { document, _ in
            guard let document = document, document.exists else {
                // TODO: find a way to alert
                self.gameRoomID = ""
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
                self.gameRoomID = ""
            }
        }
    }
}
