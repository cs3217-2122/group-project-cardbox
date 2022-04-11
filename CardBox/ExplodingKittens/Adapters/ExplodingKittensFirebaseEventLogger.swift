//
//  ExplodingKittensFirebaseEventLogger.swift
//  CardBox
//
//  Created by Stuart Long on 4/4/22.
//
import Foundation

class ExplodingKittensFirebaseEventLogger: FirebaseEventLogger, Codable {
    // TODO: set back to private
    var type: String
    private var timeStamp = NSDate().timeIntervalSince1970

    init(gameEvent: GameEvent) {
        self.type = String(describing: Swift.type(of: gameEvent))
    }
}
