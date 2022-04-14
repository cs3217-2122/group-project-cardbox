//
//  InputTextResponse.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/4/22.
//
import Foundation

class InputTextResponse: Response {
    var value: String

    init(requestId: UUID, value: String) {
        self.value = value
        super.init(requestId: requestId)
    }

    private enum CodingKeys: String, CodingKey {
        case value
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(String.self, forKey: .value)
        try super.init(from: decoder)
    }
}
