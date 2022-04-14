//
//  OptionsResponse.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/4/22.
//

import Foundation

struct OptionsResponse: Response {
    var id = UUID()
    var requestId: UUID
    var value: String
}
