//
//  IntRequest.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 11/4/22.
//

import Foundation

class IntRequest: Request {
    private(set) var minValue: Int?
    private(set) var maxValue: Int?

    init(description: String,
         fromPlayer: Player,
         toPlayer: Player,
         callback: Callback,
         minValue: Int,
         maxValue: Int) {
        self.minValue = minValue
        self.maxValue = maxValue
        super.init(description: description, fromPlayer: fromPlayer, toPlayer: toPlayer, callback: callback)
    }

    private enum CodingKeys: String, CodingKey {
        case minValue
        case maxValue
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.minValue = try container.decode(Int.self, forKey: .minValue)
        self.maxValue = try container.decode(Int.self, forKey: .maxValue)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.minValue, forKey: .minValue)
        try container.encode(self.maxValue, forKey: .maxValue)
        try super.encode(to: encoder)
    }
}
