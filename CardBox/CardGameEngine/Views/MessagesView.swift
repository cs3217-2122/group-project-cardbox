//
//  MessageView.swift
//  CardBox
//
//  Created by user213938 on 4/17/22.
//

import SwiftUI

struct MessageView: View {
    let message: Message
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Text(message.title)
            Text(message.description)
            Button("OK") {
                onDismiss()
            }
        }
    }
}

struct MessagesView: View {
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    var overlay: some View {
        NoInteractionOverlayView()
    }

    var body: some View {
        if let message = gameRunnerViewModel.localMessages.first {
            ZStack {
                overlay
                MessageView(message: message, onDismiss: {
                    gameRunnerViewModel.dismissMessage(message)
                })
                    .contentShape(Rectangle())
                    .padding(10)
                    .background(Color.white)
            }
        }
    }
}
