//
//  ExplodingKittensInitialCardFrequencies.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/3/22.
//

enum ExplodingKittensInitialCardFrequencies{
    case attack
    case favor
    case nope
    case seeTheFuture
    case shuffle
    case skip
    case random
    
    var rawValue: Int {
        switch self{
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
        case .random:
            return 4
        }
    }
}
