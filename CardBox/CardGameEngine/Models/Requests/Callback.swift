//
//  Callback.swift
//  CardBox
//
//  Created by Stuart Long on 14/4/22.
//

struct Callback: Codable {
    private(set) var callback: (Response) -> Void

    init(callback: @escaping (Response) -> Void = { _ in
    }) {
        self.callback = callback
    }

    init(from decoder: Decoder) throws {
        // do nothing
        self.callback = { _ in

        }
    }

    func encode(to encoder: Encoder) throws {
        // do nothing
    }
}
