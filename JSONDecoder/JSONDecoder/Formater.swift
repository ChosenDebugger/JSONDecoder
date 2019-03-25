//
//  ToString.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/22.
//  Copyright © 2019 齐旭晨. All rights reserved.
//

import Foundation

class Formater {
    
    var SPACE_CHAR = Character(" ")
    var INDENT_SIZE = 2
    var callDepth = 0
    
    func format (jsonObject:JsonObject) ->String{
        var stringBuilder = ""
        stringBuilder.append(getIndentString())
        stringBuilder.append("{")
        callDepth += 1
        
        let keyValues = jsonObject.getAllKeyValue()
        let size = keyValues.count
        
        var i = 0
        
        for (key, value) in keyValues{
            stringBuilder.append("\n")
            stringBuilder.append(getIndentString())
            stringBuilder.append("\"")
            stringBuilder.append(key)
            stringBuilder.append("\"")
            stringBuilder.append(":")
            
            switch value! {
            case let obj as JsonObject:
                stringBuilder.append("\n")
                stringBuilder.append(format(jsonObject:obj))
            case let arr as JsonArray:
                stringBuilder.append("\n")
                stringBuilder.append(format(jsonArray:arr))
            case let str as String:
                stringBuilder.append("\"")
                stringBuilder.append(str)
                stringBuilder.append("\"")
            case let num as Int32:
                stringBuilder.append(String(num))
            default:
                stringBuilder.append("error")
//                let temp = value as! String
//                stringBuilder.append(temp)
//                stringBuilder.append(value as! Character)
            }
            
            if i < size-1{
                stringBuilder.append(",")
            }
            i = i+1
        }
        callDepth -= 1
        stringBuilder.append("\n")
        stringBuilder.append(getIndentString())
        stringBuilder.append("}")
        
        return stringBuilder
    }
    
    func format(jsonArray:JsonArray) -> String{
        var stringBuilder = ""
        
        stringBuilder.append(getIndentString())
        stringBuilder.append("[")
        callDepth += 1
        
        let size = jsonArray.size()
        
        for index in 0..<size{
            stringBuilder.append("\n")
            
            let element = jsonArray.get(index)
            
            switch element{
            case let obj as JsonObject:
                stringBuilder.append(format(jsonObject: obj))
            case let arr as JsonArray:
                stringBuilder.append(format(jsonArray: arr))
            case let str as String:
                stringBuilder.append(getIndentString())
                stringBuilder.append("\"")
                stringBuilder.append(str)
                stringBuilder.append("\"")
            default:
                stringBuilder.append(getIndentString())
                stringBuilder.append(element as! String)
            }
            
            if index < size - 1{
                stringBuilder.append(",")
            }
        }
        
        callDepth -= 1
        stringBuilder.append(getIndentString())
        stringBuilder.append("]")
        
        return stringBuilder
    }
    
    //用空格填充一个StringBuilder
    func getIndentString() -> String {
        var stringBuilder = ""
        for _ in 0 ..< (callDepth*INDENT_SIZE){
            stringBuilder.append(SPACE_CHAR)
        }
        return stringBuilder
    }
}
