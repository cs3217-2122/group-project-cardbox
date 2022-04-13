//
//  OptionsRequestView.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/4/22.
//

import SwiftUI

struct OptionsRequestView: View {

    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @State private var optionsResponse = ""

    private var optionsRequest: OptionsRequest
    private var isOnline: Bool

    init(optionsRequest: OptionsRequest, isOnline: Bool) {
        self.optionsRequest = optionsRequest
        self.isOnline = isOnline
    }

    var header: some View {
        RequestHeaderView(request: optionsRequest, isOnline: isOnline)
    }

    var overlay: some View {
        NoInteractionOverlayView()
    }

    var messageBox: some View {
        VStack {
            header
            ForEach(optionsRequest.stringRepresentationOfOptions, id: \.self) { option in
                Button {
                    optionsResponse = option
                } label: {
                    Text(option)
                        .foregroundColor(optionsResponse == option
                                         ? Color.red : Color.black)
                }
            }
            Button {
                gameRunnerViewModel.executeGameEvents(
                    [SendResponseEvent(requestId: optionsRequest.id, value: optionsResponse)]
                )
                optionsResponse = ""
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

struct OptionsRequestView_Previews: PreviewProvider {
   static var previews: some View {
       OptionsRequestView(optionsRequest:
                            OptionsRequest(description: "Choose an option",
                                           fromPlayer: Player(name: "Player 1"),
                                           toPlayer: Player(name: "Player 2"),
                                           callback: { _ in

       },
                                           stringRepresentationOfOptions: ["Option 1", "Option 2", "Option 3"]),
                          isOnline: true)
   }
}
