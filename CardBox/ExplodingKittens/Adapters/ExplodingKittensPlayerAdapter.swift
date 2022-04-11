//
//  ExplodingKittensPlayerAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 3/4/22.
//
import Foundation

class ExplodingKittensPlayerAdapter: PlayerAdapter, Codable {
    let id: UUID
    var name: String
    private var isOutOfGame: Bool
    private var cardsPlayed: Int
    private var attackCount: Int

    var gamePlayer: ExplodingKittensPlayer {
        ExplodingKittensPlayer(name: name,
                               id: id,
                               isOutOfGame: isOutOfGame,
                               cardsPlayed: cardsPlayed,
                               attackCount: attackCount)
    }

    init(_ player: ExplodingKittensPlayer) {
        self.id = player.id
        self.name = player.name
        self.isOutOfGame = player.isOutOfGame
        self.cardsPlayed = player.cardsPlayed
        self.attackCount = player.attackCount
    }
}
