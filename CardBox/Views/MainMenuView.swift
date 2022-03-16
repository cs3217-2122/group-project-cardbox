//
//  MainMenu.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        VStack {
            Text("CardBox")
                .font(.largeTitle)
            Spacer()
            Button {
                appState.page = .game
            } label: {
                Text("Play Offline")
                    .font(.title)
                    .frame(width: 400, height: 100)
                    .border(.black)
            }
            Button {
            } label: {
                Text("Host Game")
                    .font(.title)
                    .frame(width: 400, height: 100)
                    .border(.black)
            }
            Button {
            } label: {
                Text("Join Game")
                    .font(.title)
                    .frame(width: 400, height: 100)
                    .border(.black)
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
