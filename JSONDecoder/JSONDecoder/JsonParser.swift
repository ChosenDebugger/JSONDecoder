//
//  File.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/17.
//  Copyright © 2019 齐旭晨. All rights reserved.
//

import Foundation

class JsonParser{
    let tokenizer = Tokenizer()
    let parser = Parser()
    
    func main_parser(_ jsonTarget:String) -> Any{
        let reader = ReaderChar(jsonTarget)
        let tokens = tokenizer.getTokenStream(with: reader)
        
        return parser.parse(tokens)
    }
    
}
