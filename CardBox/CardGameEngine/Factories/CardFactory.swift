//
//  CardFactory.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

protocol CardFactory {
    static func initialiseDeck(gameState: GameState)

    static func distributeCards(gameState: GameState)
}
