//
//  JoinGameView.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//

import SwiftUI

struct JoinGameView: View {

    @State var gameRoomID: String = ""
    private var viewModel = JoinGameViewModel()

    var body: some View {
        Text("Enter Game Room ID")
        HStack {
            TextField("Game Room ID", text: $gameRoomID)
            Button("Submit") {
                print("submit button pressed")
                if gameRoomID.isEmpty {
                    print("game room id cannot be empty")
                } else {
                    viewModel.joinRoom(id: gameRoomID)
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
