//
//  ExplodingKittensFirebaseLogger.swift
//  CardBox
//
//  Created by Stuart Long on 4/4/22.
//

class ExplodingKittensFirebaseLogger: FirebaseLogger, Codable {
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
}
