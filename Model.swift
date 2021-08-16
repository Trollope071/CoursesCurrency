//
//  Model.swift
//  CoursesCurrency
//
//  Created by Савва Варма on 17.08.2021.
//

import UIKit

class Currency{
    var NumCode: String?
    var CharCode: String?
    var Nominal: String?
    var nominalDouble: Double?
    
    var Name: String?
    
    var Value: String?
    var valueDouble: Double?
}



class Model: NSObject, XMLParserDelegate {
    static let shared = Model()
    
    var currencies: [Currency] = []
    
    var pathForXML: String{
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
        
        if FileManager.default.fileExists(atPath: path){
            return path
        }
        
        return Bundle.main.path(forResource: "data", ofType: "xml")!
    }
    
    var urlForXML: URL{
        
        return URL(fileURLWithPath: pathForXML)
    }
    
    //загрузка XML с cbr.ru и сохранение в катологе приложения
    func loadXMLFile(data: Data){
        
    }
    
    //распарсить XML и положить его в currencies, отправить уведомление приложению об обновлении данных
    func parseXML(){
        currencies = []
       let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        
        print(currencies)
    }
    
    var currentCurrcency: Currency?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]){
        
        if elementName == "Valute"{
            currentCurrcency = Currency()
        }
        
    }
    
    var currentCharacters: String = ""
    func parser(_ parser: XMLParser, foundCharacters string: String){
        
        currentCharacters = string
    }

    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
        if elementName == "NumCode"{
            currentCurrcency?.NumCode = currentCharacters
        }
        if elementName == "CharCode"{
            currentCurrcency?.CharCode = currentCharacters
        }
        if elementName == "Nominal"{
            currentCurrcency?.Nominal = currentCharacters
            currentCurrcency?.nominalDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        if elementName == "Name"{
            currentCurrcency?.Name = currentCharacters
        }
        if elementName == "Value"{
            currentCurrcency?.Value = currentCharacters
            currentCurrcency?.valueDouble = Double(currentCharacters.replacingOccurrences(of: ",", with: "."))
        }
        
        if elementName == "Valute"{
            currencies.append(currentCurrcency!)
        }
    }

    

    
}


