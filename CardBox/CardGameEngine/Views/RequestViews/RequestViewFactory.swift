//
//  RequestViewFactory.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/4/22.
//

import SwiftUI

struct RequestViewFactory: View {
    let request: Request
    let isOnline: Bool

    var body: some View {
        if let intRequest = request as? IntRequest {
            IntRequestView(intRequest: intRequest, isOnline: isOnline)
        }
    }
}
