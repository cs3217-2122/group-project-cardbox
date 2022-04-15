//
//  CardFactory.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

protocol CardFactory {
    static func initialiseDeck(gameState: GameState)

    // TODO: check if this is needed, or should combine with initialiseDeck
    static func distributeCards(gameState: GameState)
}
