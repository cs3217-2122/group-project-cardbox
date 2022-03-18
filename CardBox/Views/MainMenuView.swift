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
                MenuButtonsView()
            }
        }
    }
}

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        Text("stub")
    }
}
