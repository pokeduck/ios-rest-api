//
// User.swift
//
// Created by Ben for ios-rest-api on 2021/12/21.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya

struct UserResponseEntity: Codable {
    let login: String?
    let id: Int?
    let avatarUrl: String?
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case avatarUrl = "avatar_url"
    }
}



struct UserEndpoint: AuthorizeCodableTargetType,GithubHost {

    typealias ResponseType = UserResponseEntity
    
    typealias RequestType = EmptyCodable
        
    var path: String = "/user"
    
    var method: Method = .get
    
    var task: Task {
        .requestPlain
    }
    
    var headers: [String : String]? {
        ["Accept":"application/vnd.github.v3+json"]
    }
    
}
