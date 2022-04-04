//
//  GameRunnerDelegate.swift
//  CardBox
//
//  Created by user213938 on 4/4/22.
//

import SwiftUI

class GameRunnerDelegate: ObservableObject {
    var runner: GameRunnerProtocol

    init(runner: GameRunnerProtocol) {
        self.runner = runner
    }
}
