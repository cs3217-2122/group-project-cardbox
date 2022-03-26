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

    static let nonActionCards: Set<ExplodingKittensCardType> = [
        .random1,
        .random2,
        .random3
    ]
    static let actionCards: Set<ExplodingKittensCardType> = [
        .attack,
        .favor,
        .nope,
        .seeTheFuture,
        .shuffle,
        .skip,
        .favor
    ]
    static var playableCards: Set<ExplodingKittensCardType> {
        nonActionCards.union(actionCards)
    }
}
