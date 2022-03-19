//
//  WinnerGenerator.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

protocol WinnerGenerator {
    func getWinner(gameRunner: GameRunnerReadOnly) -> Player?
}
