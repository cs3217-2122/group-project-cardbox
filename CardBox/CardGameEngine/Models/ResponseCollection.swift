//
//  ResponseCollection.swift
//  CardBox
//
//  Created by user213938 on 4/15/22.
//

class ResponseCollection: Identifiable, Codable {
    private var responses: [Response]

    init(_ responses: [Response]) {
        self.responses = responses
    }

    convenience init() {
        self.init([])
    }

    var first: Response? {
        responses.first
    }

    func first(where predicate: (Request) -> Bool) -> Response? {
        first(where: predicate)
    }

    func append(_ response: Response) {
        responses.append(response)
    }

    func removeAll(where predicate: (Response) -> Bool) {
        responses.removeAll(where: predicate)
    }

    enum ObjectTypeKey: CodingKey {
        case type
    }

    enum ResponseType: String, Codable {
        case inputTextResponse
        case optionsResponse
        case intResponse
    }

    enum CodingKeys: CodingKey {
        case responses
    }

    static func decodeResponse(from decoder: Decoder, type: ResponseType) -> Response? {
        switch type {
        case .inputTextResponse:
            return try? InputTextResponse(from: decoder)
        case .intResponse:
            return try? IntResponse(from: decoder)
        case .optionsResponse:
            return try? OptionsResponse(from: decoder)
        }
    }

    static func getTypeFromResponse(_ response: Response) -> ResponseType? {
        switch response {
        case is InputTextResponse:
            return .inputTextResponse
        case is OptionsResponse:
            return .optionsResponse
        case is IntResponse:
            return .intResponse
        default:
            return nil
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let objectsArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.responses)

        var items = [Response]()
        var array = objectsArray
        while !array.isAtEnd {
            guard let object = try? array.nestedContainer(keyedBy: ObjectTypeKey.self) else {
                continue
            }

            guard let responseType = try? object.decode(
                ResponseType.self,
                forKey: ObjectTypeKey.type
            ) else {
                continue
            }

            let decoder = try object.superDecoder()
            let response: Response? = ResponseCollection.decodeResponse(from: decoder, type: responseType)
            if let response = response {
                items.append(response)
            }
        }

        self.responses = items
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var objectsArray = container.nestedUnkeyedContainer(forKey: CodingKeys.responses)
        responses.forEach { response in
            let type: ResponseType? = ResponseCollection.getTypeFromResponse(response)

            guard let type = type else {
                return
            }

            var object = objectsArray.nestedContainer(keyedBy: ObjectTypeKey.self)

            try? object.encode(type, forKey: ObjectTypeKey.type)

            let encoder = object.superEncoder()
            try? response.encode(to: encoder)
        }
    }

    func getResponses() -> [Response] {
        responses
    }
}
