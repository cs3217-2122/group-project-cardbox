//
//  DeckPositionView.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

import SwiftUI

struct PositionRequestView: View {
    @State private var position: Int = 1
    @EnvironmentObject var gameRunnerViewModel: ExplodingKittensGameRunner

    private var dispatchPositionResponse: (Int) -> Void
    private var toggleShowPositionRequestView: (Bool) -> Void
    private var size: Int

    init(dispatchPositionResponse: @escaping (Int) -> Void,
         toggleShowPositionRequestView: @escaping (Bool) -> Void,
         size: Int) {
        self.dispatchPositionResponse = dispatchPositionResponse
        self.toggleShowPositionRequestView = toggleShowPositionRequestView
        self.size = size
    }

    var minusButton: some View {
        Button(action: {
            if position > 1 {
                self.position -= 1
            }
        }) {
            Text("-")
        }
    }

    var addButton: some View {
        Button(action: {
            if position < size {
                self.position += 1
            }
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
                dispatchPositionResponse(position - 1)
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
