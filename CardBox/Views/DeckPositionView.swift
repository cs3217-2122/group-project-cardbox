//
//  DeckPositionView.swift
//  CardBox
//
//  Created by mactest on 16/03/2022.
//

import SwiftUI

struct DeckPositionView: View {
    let gameRunner: GameRunner
    @State private var position: Int = 0

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.position -= 1
                }) {
                    Text("-")
                }
                Text(position.description)
                Button(action: {
                    self.position += 1
                }) {
                    Text("+")
                }
            }
            Button(action: {
                gameRunner.dispatchDeckPositionResponse(offsetFromTop: position)
                gameRunner.hideDeckPositionRequest()
            }) {
                Text("Submit")
            }
        }
    }
}
