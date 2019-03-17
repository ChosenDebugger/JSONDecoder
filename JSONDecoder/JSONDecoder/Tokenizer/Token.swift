//
//  File.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/16.
//  Copyright © 2019 齐旭晨. All rights reserved.
//

import Foundation

enum TokenType : UInt16
{
    case BEGIN_OBJECT
    case END_OBJECT
    case BEGIN_ARRAY
    case END_ARRAY
    case NULL
    case NUMBER
    case STRING
    case BOOLEAN
    case SEP_COLON
    case SEP_COMMA
    case END_DOCUMENT
    
    //Maybe we should try [Tupe]
    //var value?
}

class Token
{
    var tokenType:TokenType?
    var value:String?
    
    init(){
        self.tokenType = nil
        self.value = nil
    }
    
    init(tokenType:TokenType, value:String) {
        self.tokenType = tokenType
        self.value = value
    }
    
    func getTokenType()->TokenType{
        return tokenType!
    }
    
    func setTokenType(tokenType:TokenType){
        self.tokenType = tokenType
    }
    
    func getValue()->String{
        return value!
    }
    
    func setValue(value:String){
        self.value = value
    }
    
    //Where is toString ??
}
