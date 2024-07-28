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
    
    lazy var mainStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .fill
        
        stackView.backgroundColor = .blue
        
        return stackView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    
    }
    
    func setupUI() {
        self.view.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    

    func bind(reactor: ProductReactor) {
        
    }

}
