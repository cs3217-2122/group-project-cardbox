//
//  DeckPositionView.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

import SwiftUI

struct PositionRequestView: View {
    @State private var position: Int = 1
    @Binding var cardPositionRequest: CardPositionRequest

    var minusButton: some View {
        Button(action: {
            self.position = max(self.position - 1, cardPositionRequest.minValue ?? 1)
        }) {
            Text("-")
        }
    }

    var addButton: some View {
        Button(action: {
            if let maxValue = cardPositionRequest.maxValue {
                self.position = min(self.position + 1, maxValue)
            } else {
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
                cardPositionRequest.executeCallback(value: position)
                cardPositionRequest.hideRequest()
                self.position = 1
            }) {
                Text("Submit")
            }
        }
        .contentShape(Rectangle())
        .padding(10)
        .background(Color.white)
    }

    var body: some View {
        if cardPositionRequest.isShowing {
            ZStack {
                overlay
                messageBox
            }
        }
    }
}
