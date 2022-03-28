//
//  CardRequest.swift
//  CardBox
//
//  Created by mactest on 27/03/2022.
//

struct CardPositionRequest {
    private(set) var isShowing = false
    private var callback: ((Int) -> Void)?
    private(set) var minValue: Int?
    private(set) var maxValue: Int?

    init() {
    }

    func executeCallback(value: Int) {
        guard let callbackUnwrapped = callback else {
            return
        }
        callbackUnwrapped(value)
    }

    mutating func showRequest(callback: @escaping (Int) -> Void, minValue: Int = 1, maxValue: Int? = nil) {
        self.isShowing = true
        self.callback = callback
        self.minValue = minValue
        self.maxValue = maxValue
    }

    mutating func hideRequest() {
        self.isShowing = false
        self.callback = nil
        self.minValue = nil
        self.maxValue = nil
    }
}
