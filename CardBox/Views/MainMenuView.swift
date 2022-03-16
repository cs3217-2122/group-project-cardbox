//
//  MainMenu.swift
//  CardBox
//
//  Created by Bernard Wan on 14/3/22.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        VStack {
            Text("CardBox")
                .font(.largeTitle)
            Spacer()
            Button {
            } label: {
                Text("Host Game")
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
