//
//  ProductView.swift
//  aladinSearchApp
//
//  Created by 박성영 on 8/4/24.
//

import UIKit

class ProductView: UIView {

    private lazy var mainStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var rightStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var priceStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var priceStandardLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var priceSalesLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var productImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private lazy var descriptionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.addSubview(mainStackView)
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        
        mainStackView.addArrangedSubview(productImageView)
        
        mainStackView.addArrangedSubview(rightStackView)
        
        rightStackView.addArrangedSubview(titleLabel)
        rightStackView.addArrangedSubview(priceStackView)
        
        priceStackView.addArrangedSubview(priceStandardLabel)
        priceStackView.addArrangedSubview(priceSalesLabel)
        
        productImageView.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.height.equalTo(100)
        }
        
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
    }
    
    func configure(with productData : ProductData?) {
        if let aladinData = productData?.aladinData {
            ImageManager.shared.setImage(link: aladinData.cover) { [weak self] image in
                self?.productImageView.image = image
            }
        }
        
        titleLabel.text = productData?.aladinData?.title
        
        if let priceStandard = productData?.aladinData?.priceStandard {
            priceStandardLabel.text = priceStandard.isEmpty ? "" : "\(priceStandard)원"
        }
        
        if let priceSales = productData?.aladinData?.priceSales {
            priceSalesLabel.text = priceSales.isEmpty ? "" : "\(priceSales)원"
        }
        
        if let description = productData?.aladinData?.description {
            descriptionLabel.text = description.isEmpty ? "" : description
        }
        
    }
    
}
