//
//  PlayerViewModel.swift
//  CardBox
//
//  Created by mactest on 13/03/2022.
//

import SwiftUI

class PlayerViewModel: ObservableObject {
    var player: Player

    init(player: Player) {
        self.player = player
    }
}
