//
//  JTNetworkManager.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import Moya

let JTNetworkManager = MoyaProvider<JTNetworkService>()

enum JTNetworkPath: String {
    case getPost = "/posts"
    case getComment = "/comments"
}

enum JTNetworkService {
    case getPost(path: JTNetworkPath, pageIdx: Int)
    case getComment(path: JTNetworkPath, id: String)
}

extension JTNetworkService: TargetType {
    var baseURL: URL { return URL(string: "https://jsonplaceholder.typicode.com")!}
    
    var path: String {
        switch self {
        case .getPost(let path, _): return path.rawValue
        case .getComment(let path, _): return path.rawValue
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .getPost(_, _):
            return """
            [{
            "userId": 1,
            "id": 1,
            "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
            "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
            }]
            """.utf8Encoded
        case .getComment(_, _):
            return """
            [{
            "postId": 1,
            "id": 1,
            "name": "id labore ex et quam laborum",
            "email": "Eliseo@gardner.biz",
            "body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"
            }]
            """.utf8Encoded
        }
        
    }
    
    var task: Task {
        switch self {
        case let .getPost(_, pageIdx):
            return .requestParameters(parameters: ["userId": "\(pageIdx)"], encoding: URLEncoding.default)
        case let .getComment(_, id):
            return .requestParameters(parameters: ["postId": "\(id)"], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}




// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

