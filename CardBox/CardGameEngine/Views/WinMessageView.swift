//
//  WinMessageView.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

import SwiftUI

struct WinMessageView: View {
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    var overlay: some View {
        NoInteractionOverlayView()
    }

    var winnerName: String {
        if let winner = gameRunnerViewModel.gameState.winner {
            return winner.name + " has won"
        }
        return ""
    }

    var messageBox: some View {
        VStack {
            Text(winnerName)
        }
        .contentShape(Rectangle())
        .padding(10)
        .background(Color.white)
    }

    var body: some View {
        if gameRunnerViewModel.gameState.isWin {
            ZStack {
                overlay
                messageBox
            }
        }
    }
}
