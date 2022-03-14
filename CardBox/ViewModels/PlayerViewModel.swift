//
//  PlayerViewModel.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

class PlayerViewModel: ObservableObject {
    var player: Player
    let gameRunner: GameRunnerReadOnly

    init(player: Player, gameRunner: GameRunnerReadOnly) {
        self.player = player
        self.gameRunner = gameRunner
    }
}
