//
//  HostGameView.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//

import SwiftUI

struct HostGameView: View {

    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private var viewModel = HostGameViewModel()

    var body: some View {
        VStack {
            Button("Host Game") {
                print("host game button pressed")
                viewModel.createRoom()
                print(viewModel.gameRoomID)
            }

            if !viewModel.gameRoomID.isEmpty {
                Text("Pass this code to your friends to join: ")
                Text(viewModel.gameRoomID)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                viewModel.removeFromRoom()
            }
        }
    }
}

struct HostGameView_Previews: PreviewProvider {
    static var previews: some View {
        HostGameView()
    }
}
