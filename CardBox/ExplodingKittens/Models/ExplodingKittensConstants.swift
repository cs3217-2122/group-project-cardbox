//
//  ExplodingKittensUtils.swift
//  CardBox
//
//  Created by mactest on 17/03/2022.
//

struct ExplodingKittensConstants {
    static var allCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensCardType.allCases
    }

    static let nonActionCards: [ExplodingKittensCard.Type] = [
        RandomCard.self
    ]
    static let actionCards: [ExplodingKittensCard.Type] = [
        AttackCard.self,
        FavorCard.self,
        SeeTheFutureCard.self,
        ShuffleCard.self,
        SkipCard.self
    ]
    static var playableCards: [ExplodingKittensCard.Type] {
        nonActionCards + actionCards
    }
}
