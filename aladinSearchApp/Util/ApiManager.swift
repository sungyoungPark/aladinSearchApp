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
    
    func requsetApi(query : String, page : String = "1" , searchTarget : Int = 0) -> Observable<[AladinData]> {
        return Observable.create { [weak self] observer in
            let url = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx"
            let myToken = Bundle.main.apiKey
            
            let page = page.isEmpty ? "1" : page
            let searchTargets = ["All", "Book", "Foreign", "eBook", "Used", "Music", "DVD"]
            
            let parameters: [String: Any] = [
                "TTBKey" : "\(myToken)",
                "Query" : "\(query)",
                "Start" : "\(page)",
                "MaxResults" : "20",
                "SearchTarget" : "\(searchTargets[searchTarget])"
            ]
            
            AF.request(url, method: .get, parameters: parameters).response { response in
                print("requestApi ---", response.request?.url)
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
    
    func requestCheckProduct(itemID : String) -> Observable<ProductData?> {
        return Observable.create { [weak self] observer in
            let myToken = Bundle.main.apiKey
            
            guard let url = "http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx?ttbkey=\(myToken)&itemIdType=ISBN&ItemId=\(itemID)&output=xml&Version=20131101&OptResult=ebookList,usedList,reviewList,ratingInfo,bestSellerRank".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            
            AF.request(url, method: .get).response { response in
                print("상품 요청 ---", response.request?.url)
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    guard let productData = self?.parseProductData(xmlData: data) else { return }
                    
                    observer.onNext(productData)
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
    
    func parseProductData(xmlData: Data) -> ProductData? {
        let parserManager = XMLParserManager()
        let items = parserManager.parseProductXML(data: xmlData)
        return items
    }
    
}
