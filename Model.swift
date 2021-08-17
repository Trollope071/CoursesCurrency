
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
    
    var currentDate: String = ""
    
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
    func loadXMLFile(date: Date?){
        var strUrl = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
        
        if date != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            strUrl = strUrl+dateFormatter.string(from: date!)
            
        }
        let url = URL(string: strUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, responce, error) in
            if error == nil {
                let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]+"/data.xml"
                let urlForSave = URL(fileURLWithPath: path)
                do{
                    try data?.write(to: urlForSave)
                    print("Файл загружен")
                    self.parseXML()
                }catch{
                    print("Error when save data: \(error.localizedDescription)")
                }
                
            }else {
                print("error when loadXMLFile: "+error!.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    //распарсить XML и положить его в currencies, отправить уведомление приложению об обновлении данных
    func parseXML(){
        currencies = []
       let parser = XMLParser(contentsOf: urlForXML)
        parser?.delegate = self
        parser?.parse()
        
        print("Данные обновлены")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DataRefreshed"), object: self)
    }
    
    var currentCurrcency: Currency?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]){
        if elementName == "ValCurs"{
            if let currentDateString = attributeDict["Date"] {
                currentDate = currentDateString
        }
    }
        
        
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


