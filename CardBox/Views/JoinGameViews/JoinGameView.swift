//
//  JoinGameView.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//

import SwiftUI

struct JoinGameView: View {

    @State var gameRoomID: String = ""
    @ObservedObject private var viewModel = JoinGameViewModel()
    private var playerViewModel = PlayerViewModel()

    var body: some View {

        if !viewModel.isJoined {
            Text("Enter Game Room ID")
            HStack {
                TextField("Game Room ID", text: $gameRoomID)
                Button("Submit") {
                    print("submit button pressed")
                    if gameRoomID.isEmpty {
                        // TODO: Change to popup or alert or something
                        print("game room id cannot be empty")
                    } else {
                        viewModel.joinRoom(id: gameRoomID, playerViewModel: playerViewModel)
                    }
                }
            }
        } else {
            JoinGameLobbyView(viewModel: viewModel, playerViewModel: playerViewModel)
        }
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
    }
}
