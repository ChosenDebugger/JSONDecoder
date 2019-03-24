//
//  JsonObject.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/17.
//  Copyright © 2019 齐旭晨. All rights reserved.
//

import Foundation

class JsonObject{
    var dict = Dictionary<String, Any?>()
    
    func put(_ key:String, _ value:Any){
        dict[key] = value
    }
    
    func get(_ key:String) ->Dictionary<String, Any>{
        return dict[key] as! Dictionary<String, Any>
    }
    
    func isEmpty() -> Bool {
        return dict.isEmpty
    }
    
    func getAllKeyValue() -> [(String, Any?)]{
        var allTupe = Array<(String, Any?)>()
        
        for (key, value) in dict{
            allTupe.append((key, value))
        }
        return allTupe
    }
    
    func toString() -> String{
        let formater = Formater()
        return formater.format(jsonObject: self)
    }
}
