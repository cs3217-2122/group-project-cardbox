//
//  ExplodingKittensFirebaseLogger.swift
//  CardBox
//
//  Created by Stuart Long on 4/4/22.
//

class ExplodingKittensFirebaseLogger: FirebaseLogger {
    var logs: [ExplodingKittensFirebaseEventLogger]

    init() {
        self.logs = []
    }

    func append(_ gameEvents: [GameEvent]) {
        for gameEvent in gameEvents {
            logs
                .append(ExplodingKittensFirebaseEventLogger(gameEvent: gameEvent))
        }
    }

    func appendToFront(_ oldLogs: [ExplodingKittensFirebaseEventLogger]) {
        var newLog = oldLogs
//        for log in logs {
//            newLog.append(log)
//        }
        for log in self.logs {
            newLog.append(log)
        }
        
        // TODO: remove after testing
        for log in newLog {
            print(log.type)
        }
        self.logs = newLog
    }

    private enum CodingKeys: String, CodingKey {
        case logs
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.logs = try container.decode([ExplodingKittensFirebaseEventLogger].self, forKey: .logs)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(logs, forKey: .logs)
    }
}
