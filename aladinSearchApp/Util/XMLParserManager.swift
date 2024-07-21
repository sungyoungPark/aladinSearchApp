//
//  XMLParserDelegate.swift
//  aladinSearchApp
//
//  Created by 박성영 on 7/14/24.
//

import Foundation

class XMLParserManager: NSObject, XMLParserDelegate {
    private var items: [AladinData] = []
    private var currentElement = ""
    private var currentItem: AladinData?
    private var currentTitle = ""
    private var currentLink = ""
    private var currentCover = ""
    private var currentIsbn = ""

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
            currentIsbn = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title" :
            currentTitle += string
        case "link" :
            currentLink += string
        case "cover" :
            currentCover += string
        case "isbn" :
            currentIsbn += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let item = AladinData(title: currentTitle, link: currentLink, cover: currentCover.trimmingCharacters(in: .whitespacesAndNewlines), isbn: currentIsbn)
            items.append(item)
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML Parse Error: \(parseError.localizedDescription)")
    }
}

