//
//  ExtendedProperties.swift
//  CardBox
//
//  Created by mactest on 17/03/2022.
//

protocol ExtendedProperties: AnyObject {
    var additionalParams: [String: String] { get set }

    func getAdditionalParams(key: String) -> String?
    func setAdditionalParams(key: String, value: String)
}

extension ExtendedProperties {
    func getAdditionalParams(key: String) -> String? {
        self.additionalParams[key]
    }

    func setAdditionalParams(key: String, value: String) {
        self.additionalParams[key] = value
    }
}
