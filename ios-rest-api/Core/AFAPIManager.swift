//
// AFAPIManager.swift
//
// Created by Ben for ios-rest-api on 2021/12/20.
// Copyright © 2021 Alien. All rights reserved.
//

import Alamofire
import PromiseKit
import Foundation

let AFAPI = AFAPIManager.shared

class AFAPIManager {
    static let shared = AFAPIManager()
    
    private static let decoder = JSONDecoder()
    
    private let validator: DataRequest.Validation = { (request, reponse, data) -> Request.ValidationResult in
        
        return .success(())
        
    }
    
    init() {
        AF.session.configuration.timeoutIntervalForRequest = 3
        AF.session.configuration.timeoutIntervalForResource = 3
    }
    
    func request<D: Decodable>(_ endpoint: URLRequestConvertible) -> Promise<D> {
        AF.request(endpoint)
            .validate(validator)
            .validate()
            .responseDecodable(D.self, decoder: Self.decoder)
    }
    
    func requestString(_ endpoint: URLRequestConvertible) -> Promise<String> {
        AF.request(endpoint)
            .validate(validator)
            .validate()
            .responseString()
            .map { $0.string }
    }
    
    
    
    
}
