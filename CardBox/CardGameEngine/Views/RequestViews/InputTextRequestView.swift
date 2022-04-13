//
//  InputTextRequestView.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/4/22.
//

import SwiftUI

struct InputTextRequestView: View {

    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @State private var inputTextResponse: String = ""

    private var inputTextRequest: InputTextRequest
    private var isOnline: Bool

    init(inputTextRequest: InputTextRequest, isOnline: Bool) {
        self.inputTextRequest = inputTextRequest
        self.isOnline = isOnline
    }

    var header: some View {
        RequestHeaderView(request: inputTextRequest, isOnline: isOnline)
    }

    var overlay: some View {
        NoInteractionOverlayView()
    }

    var messageBox: some View {
        VStack {
            header
            TextField("Type your response here", text: $inputTextResponse)                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button {
                gameRunnerViewModel.executeGameEvents(
                    [SendResponseEvent(requestId: inputTextRequest.id, value: inputTextResponse)]
                )
                inputTextResponse = ""
            } label: {
                Text("Submit")
            }
        }
        .frame(width: (1 / 2) * UIScreen.main.bounds.width)
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

 struct InputTextRequestView_Previews: PreviewProvider {
    static var previews: some View {
        InputTextRequestView(inputTextRequest:
                                InputTextRequest(description: "Input your response",
                                                 fromPlayer: Player(name: "Player 2"),
                                                 toPlayer: Player(name: "Player 1 "),
                                                 callback: { _ in
        },
                                                 isValidInput: { _ in true }
                                                ),
                       isOnline: false)
    }
 }
