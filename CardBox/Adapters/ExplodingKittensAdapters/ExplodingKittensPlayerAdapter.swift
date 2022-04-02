//
//  ExplodingKittensPlayerAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 3/4/22.
//
import SwiftUI

class ExplodingKittensPlayerAdapter: PlayerAdapter {
    // TODO: create exploding kittens player adapter class
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

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case isOutOfGame
        case cardsPlayed
        case attackCount
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.isOutOfGame = try container.decode(Bool.self, forKey: .isOutOfGame)
        self.cardsPlayed = try container.decode(Int.self, forKey: .cardsPlayed)
        self.attackCount = try container.decode(Int.self, forKey: .attackCount)

//        super.init()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(isOutOfGame, forKey: .isOutOfGame)
        try container.encode(cardsPlayed, forKey: .cardsPlayed)
        try container.encode(attackCount, forKey: .attackCount)
    }
}
