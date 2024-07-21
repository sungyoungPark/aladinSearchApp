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
        case search(String)
        case updateQuery(String)
    }
    
    enum Mutation {
        case loadSearchData([AladinData])
        case setQuery(String)
        case setLoading(Bool)
    }
    
    struct State {
        var query : String = ""
        var searchResult : [AladinData]? = nil
        var isLoading : Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let searchText) :
            return .concat(
                .just(.setLoading(true)),
                ApiManager.shared.requsetApi(query: searchText)
                    .map { data in
                        return .loadSearchData(data)
                    },
                .just(.setLoading(false))
            )
            
        case .updateQuery(let query) :
            return Observable.just(Mutation.setQuery(query))
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
        }
        return newState
    }
    
}
