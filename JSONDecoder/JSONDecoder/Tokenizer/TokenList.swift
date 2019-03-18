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
    
    //查看当前index 所指
    func peek() -> Token?{
        if index < tokens.count{
            return tokens[index]
        }else{
            return nil
        }
    }
    
    func peekPre() -> Token?{
        if index - 1 < 0{
            return nil
        }else{
            //might go wrong
            return tokens[index-2]
        }
    }
    
    func next() -> Token?{
        return tokens[+index]
    }
    
    func hasMore() -> Bool{
        return index < tokens.count
    }
    
    //Where is toString() ??
}

