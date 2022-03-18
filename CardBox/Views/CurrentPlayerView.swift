//
//  CurrentPlayerView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct CurrentPlayerView: View {
    @EnvironmentObject var gameRunnerViewModel: GameRunner

    var body: some View {
        if let currentPlayer = gameRunnerViewModel.players.currentPlayer {
            PlayerView(playerViewModel: PlayerViewModel(player: currentPlayer))
        }
    }
}

struct CurrentPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentPlayerView()
    }
}
