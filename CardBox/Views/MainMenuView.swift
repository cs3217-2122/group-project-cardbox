//
//  MainMenu.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct MainMenuView: View {
    // @EnvironmentObject var appState: AppState
    // let backgroundImageName = "background"

    var body: some View {
        VStack {
            Text("Peggle Game")
                .font(.largeTitle)
            Spacer()
            Button {
                //appState.page = Page.levelSelect
            } label: {
                Text("Level Select")
                    .font(.title)
                    .foregroundColor(Color.white)
                    .background(RoundedRectangle(cornerRadius: 4))
            }
            Spacer()
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
