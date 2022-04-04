//
//  ExplodingKittensFirebaseLogger.swift
//  CardBox
//
//  Created by Stuart Long on 4/4/22.
//

class ExplodingKittensFirebaseLogger: FirebaseLogger {
    private var log: [ExplodingKittensFirebaseEventLogger]
    
    init() {
        self.log = []
    }

    func append(_ gameEvents: [GameEvent])  {
        for gameEvent in gameEvents {
            log
                .append(ExplodingKittensFirebaseEventLogger(gameEvent: gameEvent))
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case log
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.log = try container.decode([ExplodingKittensFirebaseEventLogger].self, forKey: .log)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(log, forKey: .log)
    }
}
