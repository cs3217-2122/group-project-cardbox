//
//  GameActionsView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct GameActionsView: View {
    @EnvironmentObject private var gameRunnerViewModel: GameRunner
    @Binding var error: Bool

    var body: some View {
        HStack {
            Button {
                gameRunnerViewModel.endPlayerTurn()
            } label: {
                Text("End")
                    .font(.title)
                    .frame(width: 70, height: 50)
                    .border(Color.black)
            }
            Button {
            } label: {
                Text("Play")
                    .font(.title)
                    .frame(width: 70, height: 50)
                    .border(Color.black)
            }
        }
        // TODO: Make error appear and fade out when button pressed and invalid combo
        Text(error ? "Invalid combination" : "Valid combination")
            .foregroundColor(error ? Color.red : Color.black)
    }
}

struct GameActionsView_Previews: PreviewProvider {
    static var previews: some View {
        GameActionsView(error: .constant(false))
    }
}
