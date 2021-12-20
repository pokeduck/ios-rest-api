//
// DeleteDelay.swift
//
// Created by Ben for ios-rest-api on 2021/11/29.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya

struct DeleteDelayRequest: CodableTargetType,HttpbinHost {
    typealias ResponseType = EmptyCodable
    
    typealias RequestType = EmptyCodable
    
    var path: String {
        return "/delay/\(delayTime)"
    }
    
    var method: Method = .delete
    
    var task: Task {
        .requestPlain
    }
    
    let delayTime: Int
    
}

