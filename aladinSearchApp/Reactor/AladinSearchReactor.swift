//
//  AladinSearchReactor.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/14/24.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

class AladinSearchReactor : Reactor {
    let initialState = State()
    
   
    enum Action {
        case search(String,Int)
        case loadNextPage(Int)
        case selectedProcut(IndexPath)
    }
    
    enum Mutation {
        case loadSearchData([AladinData])
        case setQuery(String)
        case setLoading(Bool)
        case setProductData(ProductData?)
    }
    
    struct State {
        var query : String = ""
        var searchResult : [AladinData]? = nil
        var isLoading : Bool = false
        var productData : ProductData? = nil
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let searchText, let searchTarget) :
            return .concat(
                .just(.setLoading(true)),
                .just(.setQuery(searchText)),
                ApiManager.shared.requsetApi(query: searchText, searchTarget: searchTarget)
                    .map { data in
                        return .loadSearchData(data)
                    }
                    .concat(Observable.just(.setLoading(false)))
            )
        case .loadNextPage(let searchTarget) :
            print("loadNextPage")
            return .concat(
                .just(.setLoading(true)),
                ApiManager.shared.requsetApi(query: currentState.query, page: String((Int(currentState.searchResult?.first?.startIndex ?? "0") ?? 0) + 1), searchTarget: searchTarget)
                    .map { data in
                        return .loadSearchData(data)
                    }
                    .concat(Observable.just(.setLoading(false)))
            )
        case .selectedProcut(let index):
            
            return ApiManager.shared.requestCheckProduct(itemID: currentState.searchResult?[index.row].isbn ?? "")
                .map { data in
                    return .setProductData(data)
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .loadSearchData(let data) :
            newState.searchResult = data
        case .setQuery(let query) :
            print("query ---", query)
            newState.query = query
        case .setLoading(let isLoad) :
            newState.isLoading = isLoad
        case .setProductData(let productData) :
            print("setProduct")
            newState.productData = productData
        }
        return newState
    }
    
}
