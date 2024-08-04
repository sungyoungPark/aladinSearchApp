//
//  MatchFeedViewCell.swift
//  SoccerBatVideoSwift
//
//  Created by 박성영 on 7/10/24.
//

import UIKit
import SnapKit

class ProductViewCell: UITableViewCell {

    private let mainStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16
        
        return stackView
    }()

    private let rightStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 10
        
        return stackView
    }()
    
    private lazy var publishDataStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let thumbImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let competitionLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let authorLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let publisherLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.selectionStyle = .none
        
        self.contentView.addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.trailing.equalTo(-16)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
        }
        
        mainStackView.addArrangedSubview(thumbImageView)
        
        thumbImageView.snp.makeConstraints { make in
            make.width.equalTo(85)
            make.height.equalTo(100)
          
        }
        
        mainStackView.addArrangedSubview(rightStackView)
        
        
        rightStackView.addArrangedSubview(titleLabel)
        rightStackView.addArrangedSubview(publishDataStackView)
        
        publishDataStackView.addArrangedSubview(authorLabel)
        publishDataStackView.addArrangedSubview(publisherLabel)
//        rightStackView.addArrangedSubview(competitionLabel)
    }
    
    func configure(with item: AladinData) {
        
        ImageManager.shared.setImage(link: item.cover) { [weak self] thumb in
            self?.thumbImageView.image = thumb
        }
        
        titleLabel.attributedText = setAttributeString(string: item.title)
        
        
        authorLabel.text = item.author
        publisherLabel.text = item.publisher
    }
    
}

extension ProductViewCell {
    
    private func setAttributeString(string : String) -> NSAttributedString? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        return attributedString
        
    }
    
}
