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
        TextField("Game Room ID", text: $gameRoomID)
            .submitLabel(.join)
    }
}

struct JoinGameView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameView()
    }
}
