//
//  JsonManager.swift
//  KmoocSwift
//
//  Created by 박성영 on 2021/09/09.
//

import Foundation
import RxSwift
import Alamofire

//https://docs.google.com/document/d/1mX-WxuoGs8Hy-QalhHcvuV17n50uGI2Sg_GHofgiePE/edit#heading=h.rwqmubemczrb

class ApiManager {

    static let shared = ApiManager()
    
    func requsetApi(query : String) -> Observable<[AladinData]> {
        return Observable.create { [weak self] observer in
            let url = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx"
            let myToken = Bundle.main.apiKey
            
            let parameters: [String: Any] = [
                "TTBKey" : "\(myToken)",
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
    
    func requestCheckProduct(itemID : String) -> Observable<AladinData?> {
        return Observable.create { [weak self] observer in
            let myToken = Bundle.main.apiKey
            
            guard let url = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=\(myToken)&itemIdType=ISBN&ItemId=\(itemID)&output=xml&Version=20131101&OptResult=ebookList,usedList,reviewListl".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            
            AF.request(url, method: .get).response { response in
                print("상품 요청 ---", response.request?.url)
                switch response.result {
                case .success(let data):
                    print("상품 상세 data ---", String(data: data!, encoding: .utf8))
                    guard let data = data else { return }
                    guard let aladinData = self?.parseXMLData(xmlData: data) else { return }
                    
                    observer.onNext(aladinData.first ?? nil)
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
