//
//  AladinData.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/14/24.
//

import Foundation

struct AladinData: Codable {
    
    var uuid = UUID()
    var title: String
    var link : String
    var cover : String
    var isbn : String
    var priceSales : String
    var priceStandard : String
    
    var author : String
    var publisher : String
    
    init() {
        self.title = ""
        self.link = ""
        self.cover = ""
        self.isbn = ""
        self.priceSales = ""
        self.priceStandard = ""
        self.author = ""
        self.publisher = ""
    }
    
}

extension AladinData : Hashable {
    
    static func == (lhs: AladinData, rhs: AladinData) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
}
