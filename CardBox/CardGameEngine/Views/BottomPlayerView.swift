//
//  CurrentPlayerView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct BottomPlayerView<PlayerArea: View>: View {
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    let playerArea: () -> PlayerArea

    var body: some View {
        playerArea()
    }
}

struct CurrentPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
