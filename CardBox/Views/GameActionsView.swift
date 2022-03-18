//
//  GameActionsView.swift
//  CardBox
//
//  Created by Stuart Long on 19/3/22.
//

import SwiftUI

struct GameActionsView: View {
    @EnvironmentObject var gameRunnerViewModel: GameRunner

    var body: some View {
        Button {
            gameRunnerViewModel.endPlayerTurn()
        } label: {
            Text("End")
                .font(.title)
                .frame(width: 70, height: 50)
                .border(Color.black)
        }
        // TODO: Make error appear and fade out when button pressed and invalid combo
        Text("Invalid combination")
    }
}

struct GameActionsView_Previews: PreviewProvider {
    static var previews: some View {
        GameActionsView()
    }
}
