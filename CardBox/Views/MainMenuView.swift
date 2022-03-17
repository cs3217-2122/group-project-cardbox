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
        ZStack {
            Color.red
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("CardBox")
                    .font(.system(size: 50))
                Spacer()
                Button {
                    appState.page = .game
                } label: {
                    Text("Play Offline")
                        .font(.title)
                        .frame(width: 400, height: 100)
                        .border(.black)
                        .foregroundColor(Color.orange)
                        .background(Color.blue)
                }
                Button {
                } label: {
                    Text("Host Game")
                        .font(.title)
                        .frame(width: 400, height: 100)
                        .border(.black)
                        .foregroundColor(Color.orange)
                        .background(Color.blue)
                }
                Button {
                } label: {
                    Text("Join Game")
                        .font(.title)
                        .frame(width: 400, height: 100)
                        .border(.black)
                        .foregroundColor(Color.orange)
                        .background(Color.blue)
                }
                Spacer()
            }
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
