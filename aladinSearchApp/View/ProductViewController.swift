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
    
    private lazy var mainStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var productView = {
        let view = ProductView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
 
        self.view.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()

        }
        
        mainStackView.addArrangedSubview(productView)
        
        
    }
    
    
    
    func bind(reactor: ProductReactor) {
        reactor.state
            .map { $0.productData }
            .distinctUntilChanged()
            .subscribe(onNext : { [weak self] productData in
                self?.productView.configure(with: productData)
            })
            .disposed(by: disposeBag)
    }

}
