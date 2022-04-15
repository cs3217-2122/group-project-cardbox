//
//  RequestCollection.swift
//  CardBox
//
//  Created by user213938 on 4/15/22.
//

class RequestCollection: Identifiable, Codable {
    private var requests: [Request]

    init(requests: [Request]) {
        self.requests = requests
    }

    convenience init() {
        self.init(requests: [])
    }

    func add(_ request: Request) {
        requests.append(request)
    }

    enum ObjectTypeKey: CodingKey {
        case type
    }

    enum ObjectType: String, Codable {
        case inputTextRequest
        case optionsRequest
        case intRequest
    }

    enum CodingKeys: CodingKey {
        case requests
    }

    required init(from decoder: Decoder) throws {
        print("Not working?")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        print("Why?")
        let objectsArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.requests)

        print("babu")

        var oriArray = objectsArray
        var items = [Request]()
        print(items)

        var array = objectsArray
        while !oriArray.isAtEnd {
            guard let object = try? oriArray.nestedContainer(keyedBy: ObjectTypeKey.self) else {
                continue
            }
            print(object)
            guard let type = try? object.decode(ObjectType.self,
                                                forKey: ObjectTypeKey.type) else {
                continue
            }
            let decoder = try object.superDecoder()
            let request: Request? = {
                switch type {
                case .inputTextRequest:
                    return try? InputTextRequest(from: decoder)
                case .intRequest:
                    return try? IntRequest(from: decoder)
                case .optionsRequest:
                    return try? OptionsRequest(from: decoder)
                }
            }()
            if let request = request {
                items.append(request)
            }
        }

        self.requests = items
    }

    func encode(to encoder: Encoder) throws {
        guard var container = try? encoder.container(keyedBy: CodingKeys.self) else {
            return
        }
        guard var objectsArray = try? container.nestedUnkeyedContainer(forKey: CodingKeys.requests) else {
            return
        }
        requests.forEach { request in
            let type: ObjectType? = {
                switch request {
                case is InputTextRequest:
                    return .inputTextRequest
                case is OptionsRequest:
                    return .optionsRequest
                case is IntRequest:
                    return .intRequest
                default:
                    return nil
                }
            }()

            guard let type = type else {
                return
            }

            guard var object = try? objectsArray.nestedContainer(keyedBy: ObjectTypeKey.self) else {
                return
            }
            try? object.encode(type, forKey: ObjectTypeKey.type)

            let encoder = object.superEncoder()
            print(request is InputTextRequest)
            print(request is OptionsRequest)
            print(request is IntRequest)
            print()
            try? request.encode(to: encoder)
        }
    }
}
