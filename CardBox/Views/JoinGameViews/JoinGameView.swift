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
                        viewModel.joinRoom(id: gameRoomID)
                    }
                }
            }
        } else {
            VStack {
                Text("Game Room ID: \(viewModel.joinedRoomID)")
                Text("Players in Lobby")
                ForEach(viewModel.players, id: \.self) { player in
                    Text(player)
                }
            }
        }

    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
    }
}
