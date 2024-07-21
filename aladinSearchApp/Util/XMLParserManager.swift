//
//  XMLParserDelegate.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/14/24.
//

import Foundation
//https://docs.google.com/document/d/1mX-WxuoGs8Hy-QalhHcvuV17n50uGI2Sg_GHofgiePE/edit#heading=h.rwqmubemczrb

class XMLParserManager: NSObject, XMLParserDelegate {
    private var items: [AladinData] = []
    private var currentElement = ""
    private var currentItem: AladinData?
    private var currentTitle = ""
    private var currentLink = ""
    private var currentCover = ""

    func parseXML(data: Data) -> [AladinData] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return items
    }

    // XMLParserDelegate 메서드 구현
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentTitle = ""
            currentLink = ""
            currentCover = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "cover":
            currentCover += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let item = AladinData(title: currentTitle, link: currentLink, cover: currentCover.trimmingCharacters(in: .whitespacesAndNewlines))
            items.append(item)
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML Parse Error: \(parseError.localizedDescription)")
    }
}

