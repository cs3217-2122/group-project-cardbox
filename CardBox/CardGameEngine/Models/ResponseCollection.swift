//
//  ResponseCollection.swift
//  CardBox
//
//  Created by user213938 on 4/15/22.
//

class ResponseCollection: GameEngineCollection<Response> {
    override init(_ requests: [Response]) {
        super.init(requests)
    }

    convenience init() {
        self.init([])
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

        super.init(items)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var objectsArray = container.nestedUnkeyedContainer(forKey: CodingKeys.responses)
        getCollection().forEach { item in
            let type: ResponseType? = ResponseCollection.getTypeFromResponse(item)

            guard let type = type else {
                return
            }

            var object = objectsArray.nestedContainer(keyedBy: ObjectTypeKey.self)

            try? object.encode(type, forKey: ObjectTypeKey.type)

            let encoder = object.superEncoder()
            try? item.encode(to: encoder)
        }
    }
}
