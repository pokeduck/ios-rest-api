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
class ViewController: UIViewController {

    let bag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.frame = .init(x: 100, y: 100, width: 100, height: 100)
        button.setTitle("Request", for: .normal)
        button.rx.tap
            .bind { [unowned self] in
                self.sendAPI()
            }
            .disposed(by: bag)
        view.addSubview(button)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
    
    private func sendAPI() {
        API.request(DeleteDelayRequest(delayTime: 7))
            .subscribe { response in
                print(response)
            } onError: { error in
                print(error.localizedDescription)
            }.disposed(by: bag)
    }

}
