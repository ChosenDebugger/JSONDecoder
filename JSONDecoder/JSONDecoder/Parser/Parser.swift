//
//  Parser.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/17.
//  Copyright © 2019 齐旭晨. All rights reserved.
//

import Foundation

class Parser{
    let BEGIN_OBJECT_TOKEN = 1
    let END_OBJECT_TOKEN = 2
    let BEGIN_ARRAY_TOKEN = 4
    let END_ARRAY_TOKEN = 8
    let NULL_TOKEN = 16
    let NUMBER_TOKEN = 32
    let STRING_TOKEN = 64
    let BOOLEAN_TOKEN = 128
    let SEP_COLON_TOKEN = 256
    let SEP_COMMA_TOKEN = 512
    
    var tokens = TokenList()
    
    func parse(_ tokens:TokenList) ->Any{
        self.tokens = tokens
        return parse()!
    }
    
    
    func parse() ->Any?{
        let token = tokens.next()
        
        if token == nil{
            return JsonObject()
        }
        else if token!.getTokenType() == TokenType.BEGIN_OBJECT{
            return parseJsonObject()
        }
        else if token!.getTokenType() == TokenType.BEGIN_ARRAY{
            return parseJsonArray()
        }
        else{
            print("Invalid Token")
        }
        return nil
    }

    func parseJsonObject()-> JsonObject {
        let jsonObject = JsonObject()
        var expectToken = STRING_TOKEN | END_ARRAY_TOKEN
        var key = ""
        var value = ""
        
        while tokens.hasMore(){
            let token = tokens.next()!
            let tokenType = token.getTokenType()
            let tokenValue = token.getValue()
            
            switch tokenType!{
            case .BEGIN_OBJECT:
                checkExpectToken(tokenType!, expectToken)
                jsonObject.put(key, parseJsonObject())
                expectToken = SEP_COMMA_TOKEN | END_OBJECT_TOKEN
            case .END_OBJECT:
                checkExpectToken(tokenType!, expectToken)
                return jsonObject
            case TokenType.BEGIN_ARRAY:
                checkExpectToken(tokenType!, expectToken)
                jsonObject.put(key, parseJsonArray())
                expectToken = SEP_COLON_TOKEN | END_OBJECT_TOKEN
            case .NULL:
                checkExpectToken(tokenType!, expectToken)
                //没有null 暂时用“”替代
                jsonObject.put(key, "")
            case .NUMBER:
                checkExpectToken(tokenType!, expectToken)
                if tokenValue!.contains(".") || tokenValue!.contains("e") || tokenValue!.contains("E"){
                    jsonObject.put(key, (tokenValue! as NSString).doubleValue)
                }else{
                    let num = (tokenValue! as NSString).intValue
                    if num > Int.max || num < Int.min{
                        jsonObject.put(key, num)
                    }else {
                        jsonObject.put(key, num)
                    }
                    expectToken = SEP_COMMA_TOKEN | END_OBJECT_TOKEN
                }
            case .STRING:
                checkExpectToken(tokenType!, expectToken)
                let preToken = tokens.peekPre()
                if preToken!.getTokenType() == TokenType.SEP_COLON{
                    value = token.getValue()!
                    jsonObject.put(key, value)
                    expectToken = SEP_COMMA_TOKEN | END_OBJECT_TOKEN
                }else{
                    key = token.getValue()!
                    expectToken = SEP_COLON_TOKEN
                }
            case .BOOLEAN:
                checkExpectToken(tokenType!, expectToken)
                jsonObject.put(key, (tokenValue! as NSString).boolValue)
                expectToken = SEP_COMMA_TOKEN | END_OBJECT_TOKEN
            case .SEP_COLON:
                checkExpectToken(tokenType!, expectToken)
                expectToken = NULL_TOKEN | NUMBER_TOKEN | BOOLEAN_TOKEN | STRING_TOKEN | BEGIN_OBJECT_TOKEN | BEGIN_ARRAY_TOKEN
            case .SEP_COMMA:
                checkExpectToken(tokenType!, expectToken)
                expectToken = STRING_TOKEN
            case .END_DOCUMENT:
                checkExpectToken(tokenType!, expectToken)
                return jsonObject
            default:
                print("Unexpected Token")
            }
        }
        print("Invalid Token")
        return JsonObject()
    }
    
    func parseJsonArray() -> Any{
        var expectToken = BEGIN_ARRAY_TOKEN | END_ARRAY_TOKEN | BEGIN_OBJECT_TOKEN | NULL_TOKEN | NUMBER_TOKEN | BOOLEAN_TOKEN | STRING_TOKEN
        let jsonArray = JsonArray()
        
        while tokens.hasMore(){
            let token = tokens.next()
            let tokenType = token!.getTokenType()
            let tokenValue = token!.getValue()
            
            switch tokenType! {
            case TokenType.BEGIN_OBJECT:
                checkExpectToken(tokenType!, expectToken)
                jsonArray.add(parseJsonObject())
                expectToken = SEP_COMMA_TOKEN | END_ARRAY_TOKEN
            case .BEGIN_ARRAY:
                checkExpectToken(tokenType!, expectToken)
                jsonArray.add(parseJsonArray())
                expectToken = SEP_COMMA_TOKEN | END_ARRAY_TOKEN
            case .END_ARRAY:
                checkExpectToken(tokenType!, expectToken)
                return jsonArray
            case .NULL:
                checkExpectToken(tokenType!, expectToken)
                jsonArray.add("")
                expectToken = SEP_COMMA_TOKEN | END_ARRAY_TOKEN
            case .NUMBER:
                checkExpectToken(tokenType!, expectToken)
                if tokenValue!.contains(".") || tokenValue!.contains("e") || tokenValue!.contains("E"){
                    jsonArray.add((tokenValue! as NSString).doubleValue)
                }else {
                    let num = (tokenValue! as NSString).longLongValue
                    if num > Int.max || num < Int.min{
                        jsonArray.add(num)
                    }else{
                        jsonArray.add(Int(num))
                    }
                }
                expectToken = SEP_COMMA_TOKEN | END_ARRAY_TOKEN
            case .STRING:
                checkExpectToken(tokenType!, expectToken)
                jsonArray.add(tokenValue as Any)
                expectToken = SEP_COMMA_TOKEN | END_ARRAY_TOKEN
            case .BOOLEAN:
                checkExpectToken(tokenType!, expectToken)
                jsonArray.add((tokenValue! as NSString).boolValue)
                expectToken = SEP_COMMA_TOKEN | END_ARRAY_TOKEN
            case .SEP_COMMA:
                checkExpectToken(tokenType!, expectToken)
                expectToken = STRING_TOKEN | NULL_TOKEN | NUMBER_TOKEN | BOOLEAN_TOKEN | BEGIN_ARRAY_TOKEN | BEGIN_OBJECT_TOKEN
            case .END_DOCUMENT:
                checkExpectToken(tokenType!, expectToken)
                return jsonArray
            default:
                print("Unexpected Token")
            }
        }
        print("Invalid Token")
        return jsonArray
    }
    
    func checkExpectToken(_ tokenType: TokenType, _ expectToken: Int) -> Void {
        if (tokenType.rawValue & UInt16(expectToken)) == 0{
            print("Invalid Token")
        }
    }
}
