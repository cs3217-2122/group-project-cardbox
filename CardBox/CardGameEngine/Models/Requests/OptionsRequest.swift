//
//  OptionsRequest.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 14/4/22.
//

import Foundation

class OptionsRequest: Request {
    private(set) var stringRepresentationOfOptions: [String]

    init(description: String,
         fromPlayer: Player,
         toPlayer: Player,
         callback: Callback,
         stringRepresentationOfOptions: [String]) {
        self.stringRepresentationOfOptions = stringRepresentationOfOptions
        super.init(description: description, fromPlayer: fromPlayer, toPlayer: toPlayer, callback: callback)
    }

    private enum CodingKeys: String, CodingKey {
        case stringRepresentationOfOptions
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stringRepresentationOfOptions = try container.decode([String].self, forKey: .stringRepresentationOfOptions)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = try encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.stringRepresentationOfOptions, forKey: .stringRepresentationOfOptions)
        try super.encode(to: encoder)
    }
}
