//
//  ProductData.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/21/24.
//

import Foundation

struct ProductData: Codable {
    
    var uuid = UUID()
    var aladinData : AladinData?
    var itemPage : String
    var ebook_itemId : String
    var ebook_isbn : String
    var ebook_priceSales : String
    
    init() {
        self.aladinData = nil
        self.itemPage = ""
        self.ebook_itemId = ""
        self.ebook_isbn = ""
        self.ebook_priceSales = ""
    }
    
}

extension ProductData : Hashable {
    
    static func == (lhs: ProductData, rhs: ProductData) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
}
