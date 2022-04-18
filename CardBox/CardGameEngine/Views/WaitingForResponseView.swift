//
//  WaitingForResponseView.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 18/4/22.
//

import SwiftUI

struct WaitingForResponseView: View {
    var body: some View {
        ZStack {
            NoInteractionOverlayView()
            VStack {
                Text("Actions in progress. Please be patient!")
            }
            .contentShape(Rectangle())
            .padding(10)
            .background(Color.white)
        }
    }
}

struct WaitingForResponseView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingForResponseView()
    }
}
