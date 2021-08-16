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



class Model: NSObject {
    static let shared = Model()
    
    var currencies: [Currency] = []
    
    var pathForXML: String{
        return ""
    }
    
    var urlForXML: URL?{
        return nil
    }
    
    //загрузка XML с cbr.ru и сохранение в катологе приложения
    func loadXMLFile(data: Data){
        
    }
    
    //распарсить XML и положить его в currencies, отправить уведомление приложению об обновлении данных
    func parseXML(){
        
    }
    
}


