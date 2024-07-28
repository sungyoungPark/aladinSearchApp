//
//  ProductReactor.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/28/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

class ProductReactor : Reactor {
    
    let initialState : State
    
    enum Action {
       
    }
    
    enum Mutation {
       
    }
    
    struct State {
        var productData : ProductData?
    }
    
    init(productData : ProductData?) {
        self.initialState = State(productData: productData)
    }
    
}
