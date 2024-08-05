//
//  XMLParserDelegate.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/14/24.
//

import Foundation

class XMLParserManager: NSObject, XMLParserDelegate {

    private var currentElement = ""

    private var items: [AladinData] = []
    private var aladinItem: AladinData?

    private var productData : ProductData?
    
    func parseXML(data: Data) -> [AladinData] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return items
    }
    
    func parseProductXML(data: Data) -> ProductData? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        print("aladin ---", aladinItem)
        return productData
    }

    // XMLParserDelegate 메서드 구현
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            aladinItem = AladinData()
        }
        else if elementName == "subInfo" {
            productData = ProductData()
        }
        else if elementName == "ebook" {
            
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        switch currentElement {
        case "categoryName" :
            if let _ = aladinItem {
                aladinItem?.categoryName += string
            }

        case "title" :
            if let _ = aladinItem {
                aladinItem?.title += string
            }
            
        case "link" :
            if let _ = aladinItem {
                aladinItem?.link += string
            }
            
        case "cover" :
            if let _ = aladinItem {
                aladinItem?.cover += string
            }
         
        case "isbn" :
            if let _ = productData {
                productData?.ebook_isbn += string
            }
            else if let _ = aladinItem {
                aladinItem?.isbn += string
            }
        
        case "priceSales" :
            if let _ = productData {
                productData?.ebook_priceSales += string
            }
            else if let _ = aladinItem {
                aladinItem?.priceSales += string
            }
            
        case "priceStandard" :
            if let _ = aladinItem {
                aladinItem?.priceStandard += string
            }
            
        case "itemPage" :
            productData?.itemPage += string
            
        case "itemId" :
            productData?.ebook_itemId += string
        
        case "author" :
            if let _ = aladinItem {
                aladinItem?.author += string
            }
            
        case "publisher" :
            if let _ = aladinItem {
                aladinItem?.publisher += string
            }
        
        case "pubDate" :
            if let _ = aladinItem {
                aladinItem?.pubDate += string
            }
            
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            guard let currentItem = aladinItem else { return }
            items.append(currentItem)
        }
        else if elementName == "subInfo" {
            productData?.aladinData = aladinItem
            print("productData ---", productData)
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML Parse Error: \(parseError.localizedDescription)")
    }
}

