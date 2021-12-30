//
// Moya+PromiseKit.swift
//
// Created by Ben for ios-rest-api on 2021/12/20.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya
import PromiseKit

fileprivate func retryPromise<T>(maximumRetryCount: Int = 3, delayBeforeRetry: DispatchTimeInterval = .seconds(2), _ body: @escaping () -> Promise<T>) -> Promise<T> {
    var attempts = 0
    func attempt() -> Promise<T> {
        attempts += 1
        return body().recover { error -> Promise<T> in
            guard attempts < maximumRetryCount else { throw error }
            return after(delayBeforeRetry).then(on: nil, attempt)
        }
    }
    return attempt()
}

extension MoyaAPIManager {
    func requestRetryPromise<R: CodableTargetType>(_ request: R,maximumRetryCount: Int = 3, delayBeforeRetry: DispatchTimeInterval = .seconds(2)) -> Promise<R.ResponseType> {
        retryPromise(maximumRetryCount: maximumRetryCount, delayBeforeRetry: delayBeforeRetry) { [unowned self] in
            self.requestPromise(request)
        }
    }
    func requestPromise<R: CodableTargetType>(_ request: R) -> Promise<R.ResponseType> {
        let target = MultiTarget(request)
        
        return Promise<R.ResponseType> { [unowned self] seal in
            self.provider.request(target) { result in
                switch result {
                case let .success(response):
                    if let model = try? JSONDecoder().decode(R.ResponseType.self, from: response.data) {
                        return seal.fulfill(model)
                    } else {
                        seal.reject(MoyaError.jsonMapping(response))
                    }
                case let .failure(error):
                    seal.reject(error)
                }
            }
            
        }
    }
}
