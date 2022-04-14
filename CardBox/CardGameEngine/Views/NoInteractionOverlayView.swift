//
//  NoInteractionOverlayView.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import SwiftUI

struct NoInteractionOverlayView: View {
    var body: some View {
        Rectangle()
            .background(Color.black)
            .opacity(0.5)
            .allowsHitTesting(true)
    }
}

struct NoInteractionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        NoInteractionOverlayView()
    }
}
