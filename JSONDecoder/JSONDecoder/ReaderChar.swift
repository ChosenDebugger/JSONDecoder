//
//  ReaderChar.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/16.
//  Copyright © 2019 齐旭晨. All rights reserved.
//

import Foundation

class ReaderChar
{
    let jsonTarget = ""
    let BUFFER_SIZE = 1024
    
    var reader = ""
    var buffer = [Character]()
    var index = -1              //-1 equals nothing
    var size = 0
    
    init() {
        //jsonTarget =
    }
    
    
    
    func hasMore() -> Bool{
        if index < size{
            return true
        }
        
        fillBuffer(with: jsonTarget)
        return false
    }
    
    func fillBuffer(with jsonTarget:String) -> Void {
        if jsonTarget.isEmpty{ return }
        
        let length = jsonTarget.count<BUFFER_SIZE ? jsonTarget.count : BUFFER_SIZE
        
        let indexOfBufferInJson = jsonTarget.index(jsonTarget.startIndex, offsetBy: length-1)
        reader = String(jsonTarget[...indexOfBufferInJson])
        
        index = 0
        size = length
    }
    
}
