//
//  Response.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import Foundation

class Response: Codable {
    var id = UUID()
    var requestId: UUID

    init(requestId: UUID) {
        self.requestId = requestId
    }
}
