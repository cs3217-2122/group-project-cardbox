//
//  DatabaseViewModel.swift
//  CardBox
//
//  Created by user213938 on 4/17/22.
//

import Firebase
import FirebaseFirestoreSwift

struct CardBoxMetadata: Codable {
    let type: CardBoxGame
    let createdAt: Date
    let gameRoomId: String
}

class CardBoxMetadataDatabaseManager {
    internal var db = Firestore.firestore()
    static let expiryDurationInSeconds = 60 * 60

    static func randomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement() ?? Character("") })
    }

    func getRandomCode() -> String {
        CardBoxMetadataDatabaseManager.randomString(length: 4)
    }

    private func isMetadataValid(metadata: CardBoxMetadata) -> Bool {
        let seconds = Calendar.current.dateComponents([.second], from: metadata.createdAt, to: Date()).second ?? 0

        return !(seconds > CardBoxMetadataDatabaseManager.expiryDurationInSeconds)
    }

    private func checkRandomCodeAvailability(code: String) -> Bool {
        var isAvailable = false
        db.collection("metadata").document(code).getDocument { document, _ in
            if let document = document, document.exists {
                if let data = try? document.data(as: CardBoxMetadata.self) {
                    isAvailable = self.isMetadataValid(metadata: data)
                }
            } else {
                isAvailable = true
            }
        }
        return isAvailable
    }

    func createRoomMetadata(gameRoomId: String, gameType: CardBoxGame) -> String? {
        var code = getRandomCode()
        var isAvailable = false
        for _ in 0..<3 {
            isAvailable = checkRandomCodeAvailability(code: code)
            if isAvailable {
                break
            }
            code = getRandomCode()
        }

        if !isAvailable {
            print("Too many players, try again later")
        }

        let newMetadata = CardBoxMetadata(type: gameType, createdAt: Date(), gameRoomId: gameRoomId)

        do {
            try db.collection("metadata").document(code).setData(from: newMetadata)
            return code
        } catch {
            print(error)
        }
        return nil
    }

    func getRoomMetadata(gameCode: String, callback: @escaping  (CardBoxMetadata) -> Void) {
        db.collection("metadata").document(gameCode).getDocument { document, _ in
            if let document = document, document.exists {
                if let data = try? document.data(as: CardBoxMetadata.self) {
                    callback(data)
                }
            }
        }
    }
}
