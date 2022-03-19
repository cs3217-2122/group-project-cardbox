//
//  CurrentPlayerView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct CurrentPlayerView: View {
    @EnvironmentObject private var gameRunnerViewModel: GameRunner
    @Binding var error: Bool
    var currentPlayerViewModel: PlayerViewModel

    var body: some View {
        PlayerView(playerViewModel: currentPlayerViewModel, error: $error)
    }
}

struct CurrentPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentPlayerView(error: .constant(false),
                          currentPlayerViewModel: PlayerViewModel(player: Player(name: "test")))
            .accessibilityIdentifier("currentPlayer")
    }
}
