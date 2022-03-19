//
//  DeckPositionView.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

import SwiftUI

struct PositionRequestView: View {
    @State private var position: Int = 0
    @EnvironmentObject var gameRunnerViewModel: GameRunner

    var dispatchPositionResponse: (Int) -> Void
    var toggleShowPositionRequestView: (Bool) -> Void

    var minusButton: some View {
        Button(action: {
            self.position -= 1
        }) {
            Text("-")
        }
    }

    var addButton: some View {
        Button(action: {
            self.position += 1
        }) {
            Text("+")
        }
    }

    var overlay: some View {
        Rectangle()
            .background(Color.black)
            .opacity(0.5)
            .allowsHitTesting(true)
    }

    var messageBox: some View {
        VStack {
            HStack {
                minusButton
                Text(position.description)
                addButton
            }
            Button(action: {
                dispatchPositionResponse(position)
                toggleShowPositionRequestView(false)
            }) {
                Text("Submit")
            }
        }
        .contentShape(Rectangle())
        .padding(10)
        .background(Color.white)
    }

    var body: some View {
        ZStack {
            overlay
            messageBox
        }
    }
}
