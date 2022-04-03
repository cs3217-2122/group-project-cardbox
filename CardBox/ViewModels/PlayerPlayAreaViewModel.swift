//
//  PlayerPlayAreaViewModel.swift
//  CardBox
//
//  Created by Bernard Wan on 2/4/22.
//

import SwiftUI

class PlayerPlayAreaViewModel: ObservableObject {
    var sets: [CardCollection]

    init(sets: [CardCollection]) {
        self.sets = sets
    }

    var size: Int {
        sets.count
    }
}
