//
//  RequestHeaderView.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/4/22.
//

import SwiftUI

struct RequestHeaderView: View {

    private var request: Request
    private var isOnline: Bool
    private var recipientHeader: String
    private var senderHeader: String

    init(request: Request, isOnline: Bool) {
        self.request = request
        self.isOnline = isOnline
        self.recipientHeader = "Request for " + request.toPlayer.name
        self.senderHeader = "Request from " + request.fromPlayer.name
    }

    var body: some View {
        let header: String

        if isOnline {
            header = senderHeader
        } else {
            header = recipientHeader
        }

        return VStack {
            Text(header)
                .fontWeight(.black)
                .multilineTextAlignment(.center)

            Divider().background(Color.black)

            Text(request.description).padding()
        }
    }
}
