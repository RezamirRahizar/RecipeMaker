//
//  RecipeTypesManager.swift
//  RecipeMaker
//
//  Created by Rezamir Rahizar on 29/03/2024.
//

import Foundation
import UIKit

class RecipeTypesManager: NSObject, XMLParserDelegate {
    private var recipeTypes: [String] = []
    private var currentElement: String = ""
    
    func getTypes() -> [String]? {
        guard let path = Bundle.main.path(forResource: "recipetypes", ofType: "xml") else {
            print("XML file not found")
            return nil
        }
        
        guard let parser = XMLParser(contentsOf: URL(filePath: path)) else {
            print("XML parsing failed")
            return nil
        }
        
        parser.delegate = self
        parser.parse()
        
        return recipeTypes
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        //remove unwanted whitespaces
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !data.isEmpty && currentElement == "type" {
            recipeTypes.append(data)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //reset current element
        currentElement = ""
    }
   

}
