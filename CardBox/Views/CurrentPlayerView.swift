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

    var body: some View {
        if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
            PlayerView(playerViewModel: PlayerViewModel(player: currentPlayer), error: $error)
        }
    }
}

struct CurrentPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentPlayerView(error: .constant(false))
    }
}
