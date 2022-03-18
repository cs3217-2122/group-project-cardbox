//
//  ExplodingKittensCardTYpe.swift
//  CardBox
//
//  Created by mactest on 14/03/2022.
//

enum ExplodingKittensCardType: String {
    case attack = "attack"
    case bomb = "bomb"
<<<<<<< HEAD
=======
    case defuse = "defuse"
>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753
    case favor = "favor"
    case nope = "nope"
    case seeTheFuture = "see-the-future"
    case shuffle = "shuffle"
    case skip = "skip"
<<<<<<< HEAD
    case defuse = "defuse"
    case random1 = "random-1"
    case random2 = "random-2"
    case random3 = "random-3"
    
    var initialFrequency: Int {
        switch self{
=======
    case random1 = "random-1"
    case random2 = "random-2"
    case random3 = "random-3"

    var initialFrequency: Int {
        switch self {
>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753
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
<<<<<<< HEAD
=======
        case .bomb, .defuse:
            return 0
>>>>>>> f934cefe771b291b2ad8cdd39666a5565116b753
        }
    }
}
