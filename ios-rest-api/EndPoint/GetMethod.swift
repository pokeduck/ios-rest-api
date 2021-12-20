//
// GetMethod.swift
//
// Created by Ben for ios-rest-api on 2021/11/29.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya

struct HttpBinGetResponseEntity: Codable {
    let url: String
    let origin: String
}

struct HttpBinGet: CodableTargetType,HttpbinHost {
    typealias ResponseType = HttpBinGetResponseEntity
    
    typealias RequestType = EmptyCodable
    
    var path: String = "/get"
    
    var method: Method = .get
    
    var task: Task {
        .requestPlain
    }
}
