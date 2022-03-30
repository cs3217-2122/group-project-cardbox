//
//  HostGameViewModel.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//
import Firebase

class HostGameViewModel: ObservableObject {

    @Published var gameRoomId: String = ""
    private let db = Firestore.firestore()

    func createRoom() {
        var docRef: DocumentReference?

        docRef = db.collection("rooms").addDocument(data: ["players": ["testplayer"]]) { error in
            if error != nil {
                print("error creating room")
                return
            } else {
                guard let docRef = docRef else {
                    return
                }

                print("room created with unique ID \(docRef.documentID)")
                self.gameRoomId = docRef.documentID
            }
        }
    }
}
