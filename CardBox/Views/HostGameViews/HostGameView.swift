//
//  HostGameView.swift
//  CardBox
//
//  Created by Stuart Long on 30/3/22.
//

import SwiftUI

struct HostGameView: View {

    @ObservedObject private var viewModel = HostGameViewModel()

    var body: some View {
        VStack {
            if viewModel.gameRoomID.isEmpty {
                Button("Host Game") {
                    print("host game button pressed")
                    viewModel.createRoom()
                    print(viewModel.gameRoomID)
                }
            } else {
                HostGameLobbyView(viewModel: viewModel)
            }
        }
    }
}

struct HostGameView_Previews: PreviewProvider {
    static var previews: some View {
        HostGameView()
    }
}
