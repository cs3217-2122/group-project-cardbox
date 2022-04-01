//
//  JoinGameLobbyView.swift
//  CardBox
//
//  Created by Stuart Long on 1/4/22.
//

import SwiftUI

struct JoinGameLobbyView: View {

    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject var viewModel: JoinGameViewModel

    var body: some View {
        VStack {
            Text("Game Room ID: \(viewModel.joinedRoomID)")
            Text("Players in Lobby")
            ForEach(viewModel.players, id: \.self) { player in
                Text(player)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                viewModel.removeFromRoom()
            }
        }
    }
}

struct JoinGameLobbyView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGameLobbyView(viewModel: JoinGameViewModel())
    }
}
