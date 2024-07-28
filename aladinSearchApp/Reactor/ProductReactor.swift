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
        var productData : AladinData?
    }
    
    init(productData : AladinData?) {
        self.initialState = State(productData: productData)
        print("aladinData ---", productData)
    }
    
}
