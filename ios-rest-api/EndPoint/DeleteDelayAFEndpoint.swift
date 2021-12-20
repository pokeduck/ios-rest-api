//
// DeleteDelayAFEndpoint.swift
//
// Created by Ben for ios-rest-api on 2021/12/20.
// Copyright © 2021 Alien. All rights reserved.
//

import Alamofire

struct DeleteDelayAF: URLRequestConvertible {
    
    let second: Int
    
    func asURLRequest() throws -> URLRequest {
        var request = try URLRequest.init(url: "https://httpbin.org/delay/\(second)", method: .delete)
        request.timeoutInterval = 5
        return request
    }
    
    
}
