//
//  GameRunnerViewModel.swift
//  CardBox
//
//  Created by mactest on 12/03/2022.
//

import SwiftUI

class GameRunnerViewModel: ObservableObject {
    @Published var ekGameRunner = ExplodingKittensGameRunner()

    var gameRunner: GameRunner {
        ekGameRunner.gameRunner
    }

    init() {
        ActionDispatcher.runAction(SetupGameAction(), on: gameRunner)
    }

}
