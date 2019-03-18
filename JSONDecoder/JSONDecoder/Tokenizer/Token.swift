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
    case BEGIN_OBJECT = 1
    case END_OBJECT = 2
    case BEGIN_ARRAY = 4
    case END_ARRAY = 8
    case NULL = 16
    case NUMBER = 32
    case STRING = 64
    case BOOLEAN = 128
    case SEP_COLON = 256
    case SEP_COMMA = 512
    case END_DOCUMENT = 1024
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
    
    func getTokenType()->TokenType?{
        return tokenType
    }
    
    func setTokenType(tokenType:TokenType){
        self.tokenType = tokenType
    }
    
    func getValue()->String?{
        return value
    }
    
    func setValue(value:String){
        self.value = value
    }
}
