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
            Color(red: 0.549, green: 0.015_69, blue: 0.063_74)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("CardBox")
                    .font(.system(size: 50))
                    .foregroundColor(Color.white)
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
