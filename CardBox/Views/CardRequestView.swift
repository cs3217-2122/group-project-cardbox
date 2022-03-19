//
//  CardRequestView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct CardRequestView: View {
    @EnvironmentObject var gameRunnerViewModel: GameRunner
    @State var selectedType = ""
    private var dispatchPositionResponse: (Int) -> Void
    private var toggleShowPositionRequestView: (Bool) -> Void

    init(dispatchPositionResponse: @escaping (Int) -> Void,
         toggleShowPositionRequestView: @escaping (Bool) -> Void) {
        self.dispatchPositionResponse = dispatchPositionResponse
        self.toggleShowPositionRequestView = toggleShowPositionRequestView
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
                ForEach(gameRunnerViewModel.getAllCardTypes, id: \.self) { cardType in
                    Button {
                        selectedType = cardType.rawValue
                    } label: {
                        Text(cardType.rawValue)
                            .foregroundColor(selectedType == cardType.rawValue
                                             ? Color.red : Color.blue)
                    }
                }
            }
            Button {
                dispatchPositionResponse(1) // random value
                toggleShowPositionRequestView(false)
            } label: {
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
