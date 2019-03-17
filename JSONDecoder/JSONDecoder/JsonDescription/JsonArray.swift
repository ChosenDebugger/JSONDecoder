//
//  JsonArray.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/17.
//  Copyright © 2019 齐旭晨. All rights reserved.
//

import Foundation

class JsonArray{
    var list = [Any]()
    
    func add(_ obj:Any) ->Void{
        list.append(obj)
    }
    
    func get(_ index:Int) ->Any{
        return list[index]
    }
    
    func size() ->Int{
        return list.count
    }
    
}
