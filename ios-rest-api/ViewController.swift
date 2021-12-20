//
// ViewController.swift
//
// Created by Ben for ios-rest-api on 2021/11/29.
// Copyright © 2021 Alien. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import RxSwiftExt
import PromiseKit
class ViewController: UIViewController {

    let bag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.frame = .init(x: 100, y: 100, width: 200, height: 100)
        button.setTitle("Rx Moya Request", for: .normal)

        let result = button.rx.tap
            .flatMap({ _ in
                API.request(DeleteDelayRequest.init(delayTime: 7))
            })
            .materialize()
        result.elements().bind { _ in
            print("success")
        }.disposed(by: bag)
        result.errors().bind { error in
            print("error")
        }.disposed(by: bag)
        
        view.addSubview(button)
        
        let button2 = UIButton(type: .system)
        button2.frame = .init(x: 100, y: 200, width: 200, height: 100)
        button2.setTitle("Promise Request", for: .normal)
        view.addSubview(button2)
        button2.addTarget(self, action: #selector(sendAPI), for: .touchUpInside)

    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
    
    @objc private func sendAPI() {
        
        
        retryPromise(maximumRetryCount: 3, delayBeforeRetry: .seconds(5)) {
            //return AFAPI.requestString(DeleteDelayAF.init(second: 7))
            return API.requestPromise(DeleteDelayRequest.init(delayTime: 7))
        }.done { data in
            print(data)
        }.catch { error in
            print(error.localizedDescription)
        }
//        API.request(DeleteDelayRequest(delayTime: 7))
//            .subscribe { response in
//                print(response)
//            } onError: { error in
//                print(error.localizedDescription)
//            }.disposed(by: bag)
    }

}

