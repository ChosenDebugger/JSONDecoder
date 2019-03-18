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
    
    
}
