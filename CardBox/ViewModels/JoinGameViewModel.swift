//
//  JoinGameViewModel.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//
import Firebase

class JoinGameViewModel {

    private let db = Firestore.firestore()

    func joinRoom(id: String) {
        // query database to see if this room exists, if does not, alert user
        let docRef = db.collection("rooms").document(id)

        docRef.getDocument { document, error in
            if let error = error {
                print(error)
                return
            }

            if let document = document, document.exists {
                print("exists")
            } else {
                // TODO: find a way to alert user
                print("document does not exist")
            }
        }
    }
}
