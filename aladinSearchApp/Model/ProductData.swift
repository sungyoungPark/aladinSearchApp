//
//  ProductData.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/21/24.
//

import Foundation

struct ProductData: Codable {
    
    var uuid = UUID()
    var title: String
    var link : String
    var cover : String
    var isbn : String
}
