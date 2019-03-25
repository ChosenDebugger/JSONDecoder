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
    var jsonTarget = ""
    let BUFFER_SIZE = 1024
    
    var buffer = [Character]()
    var index = 0              //-1 equals nothing
    var size = 0
    
    init(){
    }
    
    init(_ jsonTarget:String) {
        self.jsonTarget = jsonTarget
    }
    
    func peek() -> Character{
        if index - 1 >= size {
            return "\0"
        }
        return buffer[max(0, index - 1)]
    }
    
    func next() -> Character{
        if !hasMore(){
            return "\0"
        }
        
        let temp = buffer[index]
        index = index + 1
        
        return temp
    }
    
    func back() -> Void{
        index = max(0, index - 1)
    }
    
    func hasMore() -> Bool{
        if index < size{
            return true
        }
        
        fillBuffer()
        return index < size
    }
    
    func fillBuffer() -> Void {
        if jsonTarget.isEmpty{ return }
        
        buffer = [Character]()
        
        let length = jsonTarget.count<BUFFER_SIZE ? jsonTarget.count : BUFFER_SIZE
        
        let indexOfBufferInJson = jsonTarget.index(jsonTarget.startIndex, offsetBy: length-1)
        let reader = String(jsonTarget[...indexOfBufferInJson])
        
        let range = jsonTarget.startIndex...(jsonTarget.index(jsonTarget.startIndex, offsetBy: length-1))
        jsonTarget.removeSubrange(range)
        
        for character in reader{
            buffer.append(character)
        }
        
        index = 0
        size = length
    }
    
}
