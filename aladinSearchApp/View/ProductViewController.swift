//
//  ProductViewController.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/21/24.
//

import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

class ProductViewController: UIViewController, View {

    typealias Reactor = ProductReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    
    }
    
    func setupUI() {
       
    }
    

    func bind(reactor: ProductReactor) {
        
    }

}
