//
// CodableTargetType.swift
//
// Created by Ben for ios-rest-api on 2021/11/29.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya
protocol AuthorizeCodableTargetType: CodableTargetType, MoyaAuthorizable {}
extension AuthorizeCodableTargetType {
    var authorizeType: AuthorizeType {
        .bearer
    }
}
protocol CodableTargetType: TargetType {
    associatedtype ResponseType: Decodable
    associatedtype RequestType: Encodable
}
extension CodableTargetType {
    var sampleData: Data {
        Data()
    }
    var headers: [String : String]? {
        nil
    }
}


protocol GithubHost: TargetType {}
extension GithubHost {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
}

protocol HttpbinHost: TargetType {}
extension HttpbinHost {
    var baseURL: URL {
        return URL(string: "https://httpbin.org")!
    }
}


struct EmptyCodable: Codable {}
