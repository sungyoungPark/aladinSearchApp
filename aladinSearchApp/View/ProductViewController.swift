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
        
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
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
        
        mainStackView.addArrangedSubview(titleLabel)
        
    }
    
    
    
    func bind(reactor: ProductReactor) {
        reactor.state
            .map { $0.productData }
            .distinctUntilChanged()
            .subscribe(onNext : { [weak self] productData in
                print("productData ---", productData?.aladinData?.title)
                self?.titleLabel.text = productData?.aladinData?.title
            })
            .disposed(by: disposeBag)
    }

}
