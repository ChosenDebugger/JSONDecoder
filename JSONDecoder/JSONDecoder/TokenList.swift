//
//  TokenList.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/16.
//  Copyright © 2019 齐旭晨. All rights reserved.
//

import Foundation

class TokenList
{
    var tokens = [Token]()
    var index = 0
    
    func add(token:Token){
        tokens.append(token)
    }
    
    func next(){
        return tokens[index++]
    }
    
    func hasMore->Bool(){
        return index < tokens.size
    }
}
