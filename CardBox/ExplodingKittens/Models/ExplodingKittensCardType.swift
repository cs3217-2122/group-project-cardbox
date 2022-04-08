//
//  ExplodingKittensCardTYpe.swift
//  CardBox
//
//  Created by mactest on 14/03/2022.
//

enum ExplodingKittensCardType: String, CaseIterable, Codable {
    case attack = "attack"
    case bomb = "bomb"
    case defuse = "defuse"
    case favor = "favor"
    case nope = "nope"
    case seeTheFuture = "see-the-future"
    case shuffle = "shuffle"
    case skip = "skip"
    case random1 = "random-1"
    case random2 = "random-2"
    case random3 = "random-3"

    var initialFrequency: Int {
        switch self {
        case .attack:
            return 4
        case .favor:
            return 4
        case .nope:
            return 5
        case .seeTheFuture:
            return 5
        case .shuffle:
            return 4
        case .skip:
            return 4
        case .random1, .random2, .random3:
            return 4
        case .bomb, .defuse:
            return 0
        }
    }
}
