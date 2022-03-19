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

    private var dispatchPositionResponse: (Int) -> Void
    private var toggleShowPositionRequestView: (Bool) -> Void
    
    init(dispatchPositionResponse: @escaping (Int) -> Void,
         toggleShowPositionRequestView: @escaping (Bool) -> Void) {
        self.dispatchPositionResponse = dispatchPositionResponse
        self.toggleShowPositionRequestView = toggleShowPositionRequestView
    }

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
