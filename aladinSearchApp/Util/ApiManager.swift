//
//  JsonManager.swift
//  KmoocSwift
//
//  Created by 박성영 on 2021/09/09.
//

import Foundation
import RxSwift
import Alamofire

class ApiManager {

    static let shared = ApiManager()

    let decoder = JSONDecoder()
    
    let myToken = Bundle.main.apiKey
    
    let apiURL = "https://www.scorebat.com/video-api/v3/feed"
    
    func requsetApi(query : String) -> Observable<[AladinData]> {
        return Observable.create { [weak self] observer in
            let url = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx"
            
            let parameters: [String: Any] = [
                "TTBKey" : "\(self?.myToken ?? "")",
                "Query" : "\(query)",
                "Start" : "1",
                "MaxResults" : "20"
            ]
            
            AF.request(url, method: .get, parameters: parameters).response { response in
               
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    guard let aladinData = self?.parseXMLData(xmlData: data) else { return }
                    
                    observer.onNext(aladinData)
                    observer.onCompleted()
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            return Disposables.create()
        }
        
        
    }
    
    func parseXMLData(xmlData: Data) -> [AladinData]{
        let parserManager = XMLParserManager()
        let items = parserManager.parseXML(data: xmlData)
        return items
    }
    
}
