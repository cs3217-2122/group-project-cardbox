//
//  WinMessageView.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

import SwiftUI

struct WinMessageView: View {
    @EnvironmentObject var gameRunnerViewModel: ExplodingKittensGameRunner

    var overlay: some View {
        Rectangle()
            .background(Color.black)
            .opacity(0.5)
            .allowsHitTesting(true)
    }

    var winnerName: String {
        if let winner = gameRunnerViewModel.winner {
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
        if gameRunnerViewModel.isWin {
            ZStack {
                overlay
                messageBox
            }
        }
    }
}
