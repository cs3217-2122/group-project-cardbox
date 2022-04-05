//
//  CurrentPlayerView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct BottomPlayerView: View {
    @EnvironmentObject private var gameRunnerViewModel: ExplodingKittensGameRunner
    @Binding var error: Bool
    var bottomPlayerViewModel: PlayerViewModel
    @Binding var selectedPlayerViewModel: PlayerViewModel?

    var body: some View {
        PlayerView(
            playerViewModel: bottomPlayerViewModel,
            currentPlayerViewModel: bottomPlayerViewModel,
            error: $error,
            selectedPlayerViewModel: $selectedPlayerViewModel
        )
    }
}

struct CurrentPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        BottomPlayerView(
            error: .constant(false),
            bottomPlayerViewModel: PlayerViewModel(
                player: Player(
                    name: "test"
                ),
                hand: CardCollection()
            ),
            selectedPlayerViewModel: .constant(nil)
        )
        .accessibilityIdentifier("currentPlayer")
    }
}
