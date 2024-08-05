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
    
    
    private let thumbImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let publishDataLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
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
        rightStackView.addArrangedSubview(publishDataLabel)

    }
    
    func configure(with item: AladinData) {
        
        ImageManager.shared.setImage(link: item.cover) { [weak self] thumb in
            self?.thumbImageView.image = thumb
        }
        
        let title = setCategoryString(categoryName: item.categoryName).isEmpty ? item.title : "[\(setCategoryString(categoryName: item.categoryName))] \(item.title)"
        titleLabel.attributedText = setAttributeString(string: title)
        
        var pubDataText : [String?] = []
        if !(item.author.isEmpty) {
            pubDataText.append(item.author)
        }
        if !(item.publisher.isEmpty) {
            pubDataText.append(item.publisher)
        }
        if !(item.pubDate.isEmpty) {
            pubDataText.append(setPubDateString(pubDate: item.pubDate))
        }
        
        publishDataLabel.text = pubDataText.compactMap { $0 }.joined(separator: " | ")
    }
    
}

extension ProductViewCell {
    
    private func setCategoryString(categoryName : String) -> String {
        guard let category = categoryName.split(separator: ">").first else {
            return ""
        }
        return String(category)
    }
    
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
    
    private func setPubDateString(pubDate : String) -> String? {
 
        // 날짜 포맷터 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // 영문 로케일 사용
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT") // GMT 시간대 사용

        // 문자열을 Date로 변환
        if let date = dateFormatter.date(from: pubDate) {
            // 한국 시간대 설정
            let koreanFormatter = DateFormatter()
            koreanFormatter.dateFormat = "yyyy년 MM월 dd일" // 원하는 형식으로 설정
            koreanFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // 한국 시간대 설정

            // 한국 날짜로 변환
            let koreanDateString = koreanFormatter.string(from: date)
            return koreanDateString
        } else {
            print("날짜 변환 실패")
            return nil
        }
    }
    
}
