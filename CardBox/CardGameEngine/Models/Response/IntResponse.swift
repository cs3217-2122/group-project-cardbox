//
//  IntResponse.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//
import Foundation

class IntResponse: Response {
    var value: Int

    init(requestId: UUID, value: Int) {
        self.value = value
        super.init(requestId: requestId)
    }

    private enum CodingKeys: String, CodingKey {
        case value
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try container.decode(Int.self, forKey: .value)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.value, forKey: .value)
        try super.encode(to: encoder)
    }
}
