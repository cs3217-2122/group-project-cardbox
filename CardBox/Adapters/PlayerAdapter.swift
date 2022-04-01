//
//  PlayerAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 2/4/22.
//
import SwiftUI

class PlayerAdapter: Codable {
    let id: UUID
    var name: String
    private var isOutOfGame = false
    private var cardsPlayed = 0

    init(_ player: Player) {
        self.id = player.id
        self.name = player.name
        self.isOutOfGame = player.isOutOfGame
        self.cardsPlayed = player.cardsPlayed
    }
}
