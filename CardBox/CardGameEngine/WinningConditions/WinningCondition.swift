//
//  WinningCondition.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

protocol WinningCondition {
    func evaluate(gameRunner: GameRunnerReadOnly) -> Bool
}
