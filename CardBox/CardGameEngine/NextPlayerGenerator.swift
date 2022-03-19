//
//  NextPlayerGenerator.swift
//  CardBox
//
//  Created by mactest on 17/03/2022.
//

protocol NextPlayerGenerator {
    func getNextPlayer(gameRunner: GameRunnerReadOnly) -> Player?
}
