//
// API.swift
//
// Created by Ben for ios-rest-api on 2021/11/29.
// Copyright © 2021 Alien. All rights reserved.
//

import Moya
import RxSwift
import Alamofire

let API = APIManager.shared

class APIManager {
    static let shared = APIManager()
    private let requestQueue = DispatchQueue.init(label: "com.yoyo.request.thread")
    private let refreshRequestQueue = DispatchQueue.init(label: "com.yoyo.refresh.token.thread")
    private let provider = MoyaProvider<MultiTarget>(
        session: APIManager.defaultAlamofireSession(),
        plugins: [OAuthTokenPlugin(),
                  DefaultConfigurationPligun(),
                  NetworkMonitorPlugin()
                 ])
    func suspendQueue() {
        requestQueue.suspend()
    }
    func resumeQueue() {
        requestQueue.resume()
    }
    func request<R: CodableTargetType>(_ request: R) -> Single<R.ResponseType> {
        let target = MultiTarget(request)
        let result = provider.rx
            .request(target)
            .observeOn(ConcurrentDispatchQueueScheduler.init(queue: requestQueue))
            .subscribeOn(MainScheduler.instance)
            .filter(statusCode: 200)
            .map(R.ResponseType.self)
            .retry(5)
        return result
    }
    
}

class AuthManager {
    static let shared = AuthManager()
    var token: String = ""
    var isValid: Bool {
        !token.isEmpty
    }
}
///模仿 `AccessTokenPlugin`
struct OAuthTokenPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

        if !AuthManager.shared.isValid {
            return request
        }
        var request = request
        
        let authValue = "Bearer \(AuthManager.shared.token)"
        request.addValue(authValue, forHTTPHeaderField: "Authorization")

        return request
    }
}

///Default Configuration
struct DefaultConfigurationPligun: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("en-US", forHTTPHeaderField: "Accept-Language")
        return request
    }
}

struct NetworkMonitorPlugin: PluginType {
    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
            let requestURL = response.request?.url?.absoluteString ?? ""
            let body = (try? response.mapString(atKeyPath: nil)) ?? ""
            
            print("URL:\(requestURL),Body:\(body)")
        case .failure(let error):
            
            if error.isTimeout {
                print("Timeout!!!!")
            } else {
                print(error.localizedDescription)
            }
            
        }
        return result
    }
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        //API.suspendQueue()
    }
}

enum APIError: Error {
    case timeout
    case tokenInvalid
    case networkUnreach
}

extension APIManager {
    
    final class func defaultRequestMapping(for endpoint: Endpoint, closure: (Result<URLRequest, MoyaError>) -> Void) {
        do {
            let urlRequest = try endpoint.urlRequest()
            closure(.success(urlRequest))
        } catch let MoyaError.requestMapping(url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch let MoyaError.parameterEncoding(error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }

    final class func defaultEndpointMapping<Target: TargetType>(for target: Target) -> Endpoint {
        Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
    }

    final class func defaultAlamofireSession() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3
        configuration.timeoutIntervalForResource = 3
        configuration.headers = .default

        return Session(configuration: configuration, startRequestsImmediately: false)
    }

}
extension MoyaError {
    var isTimeout: Bool {
        if let aferror = errorUserInfo[NSUnderlyingErrorKey] as? AFError {
            return aferror.isTimeout
        } else {
            return false
        }
    }
}
extension AFError {
    var isTimeout: Bool {
        if isSessionTaskError,
           let error = underlyingError as NSError?,
           error.code == NSURLErrorTimedOut
        {
            return true
        }
        return false
    }
}
