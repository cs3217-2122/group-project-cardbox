//
//  IntRequestView.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import SwiftUI

struct IntRequestView: View {
    @EnvironmentObject private var gameRunnerDelegate: GameRunnerDelegate
    var gameRunnerViewModel: GameRunnerProtocol {
        gameRunnerDelegate.runner
    }

    @State private var integerResponse: Int = 1

    private var intRequest: IntRequest
    private var isOnline: Bool
    private var recipientHeader: String
    private var senderHeader: String

    init(intRequest: IntRequest, isOnline: Bool) {
        self.intRequest = intRequest
        self.isOnline = isOnline
        self.recipientHeader = "Request for " + intRequest.toPlayer.name
        self.senderHeader = "Request from " + intRequest.fromPlayer.name
    }

    var header: some View {
        let header: String
        if isOnline {
            header = senderHeader
        } else {
            header = recipientHeader
        }
        return Text(header)
            .fontWeight(.black)
            .multilineTextAlignment(.center)
    }

    var description: some View {
        Text(intRequest.description).padding()
    }

    var minusButton: some View {
        Button(action: {
            self.integerResponse = max(self.integerResponse - 1,
                                       intRequest.minValue ?? 1)
        }) {
            Text("-")
        }
    }

    var addButton: some View {
        Button(action: {
            if let maxValue = intRequest.maxValue {
                self.integerResponse = min(self.integerResponse + 1, maxValue)
            } else {
                self.integerResponse += 1
            }
        }) {
            Text("+")
        }
    }

    var overlay: some View {
        NoInteractionOverlayView()
    }

    var messageBox: some View {
        VStack {
            header
            Divider()
                .background(Color.black)
            description
            HStack {
                minusButton
                Text(integerResponse.description)
                addButton
            }
            Button(action: {
                gameRunnerViewModel.executeGameEvents([
                    SendResponseEvent(response: intRequest.createResponse(with: integerResponse))
                ])
                self.integerResponse = 1
            }) {
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

 // TODO: DELETE THIS
 struct IntRequestView_Previews: PreviewProvider {
    static var previews: some View {
        IntRequestView(intRequest:
                        IntRequest(description: "Choose a number from 1 to 5",
                                   fromPlayer: Player(name: "Player 2"),
                                   toPlayer: Player(name: "Player 1 "),
                                   minValue: 1,
                                   maxValue: 5,
                                   callback: { _ in
        }),
                       isOnline: false)
    }
 }
