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

//    private enum CodingKeys: String, CodingKey {
//        case type
//        case timeStamp
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.type = try container.decode(String.self, forKey: .type)
//        self.timeStamp = try container.decode(TimeInterval.self, forKey: .timeStamp)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(type, forKey: .type)
//        try container.encode(timeStamp, forKey: .timeStamp)
//    }
}
