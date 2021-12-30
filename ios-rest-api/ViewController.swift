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
        button.setTitle("Moya Rx", for: .normal)
        button.rx.tap
            .bind { [unowned self] in
                self.moya_RX()
            }
            .disposed(by: bag)
//        let result = button.rx.tap
//            .flatMap({ _ in
//                API.request(UserEndpoint.init()).asObservable().materialize()
//            })
//        result.elements().bind { _ in
//            print("success")
//        }.disposed(by: bag)
//        result.errors().bind { error in
//            print("error")
//        }.disposed(by: bag)
        
        view.addSubview(button)
        
        let button2 = UIButton(type: .system)
        button2.frame = .init(x: 100, y: 200, width: 250, height: 100)
        button2.setTitle("Moya Promise", for: .normal)
        view.addSubview(button2)
        button2.rx.tap
            .bind { [unowned self] in
                self.moya_Promise()
            }
            .disposed(by: bag)
        
        let button3 = UIButton(type: .system)
        button3.frame = .init(x: 100, y: 300, width: 250, height: 100)
        button3.setTitle("AF Promise", for: .normal)
        view.addSubview(button3)
        button3.rx.tap
            .bind { [unowned self] in
                self.af_Promise()
            }
            .disposed(by: bag)
        
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
    
    private func moya_RX() {
        API.request(DeleteDelayRequest.init(delayTime: 7))
            .subscribe { result in
                debugPrint("success")
            } onError: { error in
                debugPrint(error.localizedDescription)
            }.disposed(by: bag)

    }
    
    private func moya_Promise() {
        API.requestRetryPromise(DeleteDelayRequest(delayTime: 7), maximumRetryCount: 5, delayBeforeRetry: .seconds(3))
            .done { result in
                debugPrint("success")
            }
            .catch { error in
                debugPrint(error.localizedDescription)
            }
    }
    
    private func af_Promise() {
        AFAPI.requestString(DeleteDelayAF.init(second: 7))
            .done { _ in
                debugPrint("success")
            }
            .catch { error in
                debugPrint(error.localizedDescription)
            }
    }

}

