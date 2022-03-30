//
//  JoinGameView.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//

import SwiftUI

struct JoinGameView: View {

    @State var gameRoomID: String = ""

    var body: some View {
        Text("Enter Game Room ID")
        HStack {
            TextField("Game Room ID", text: $gameRoomID)
            Button("Submit") {
                print("submit button pressed")
            }
        }
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
    }
}
