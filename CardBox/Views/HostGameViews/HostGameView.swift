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
            Button("Host Game") {
                print("host game button pressed")
                viewModel.createRoom()
                print(viewModel.gameRoomId)
            }

            if !viewModel.gameRoomId.isEmpty {
                Text("Pass this code to your friends to join: ")
                Text(viewModel.gameRoomId)
            }
        }
    }
}

struct HostGameView_Previews: PreviewProvider {
    static var previews: some View {
        HostGameView()
    }
}
