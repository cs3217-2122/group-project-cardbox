//
//  CardTypeRequest.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 1/4/22.
//
struct CardTypeRequest {
    private(set) var isShowing = false
    private var callback: ((String) -> Void)?

    init() {
    }

    func executeCallback(value: String) {
        guard let callbackUnwrapped = callback else {
            return
        }
        callbackUnwrapped(value)
    }

    mutating func showRequest(callback: @escaping (String) -> Void) {
        self.isShowing = true
        self.callback = callback
    }

    mutating func hideRequest() {
        self.isShowing = false
        self.callback = nil
    }
}
