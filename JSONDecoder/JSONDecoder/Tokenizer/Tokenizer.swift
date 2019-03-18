//
//  jsonDecoder.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/17.
//  Copyright © 2019 齐旭晨. All rights reserved.
//
//  Used to drive the lexical analysis
//  Input: The Target Json text
//  Output: The Token List
//

import Foundation

class Tokenizer {
    
    var jsonString = ""
    var reader = ReaderChar()
    var tokenlist = TokenList()

    func decode(_ jsonString:String) -> Void{
        self.jsonString = jsonString
    }

    func getTokenStream(with reader:ReaderChar) -> TokenList{
        self.reader = reader
        
        tokenizer()
        
        return tokenlist
    }
    
    func tokenizer() -> Void{
        
        var token = Token()
        
        //the origin of lexical analysis
        repeat{
            token = start()!
            tokenlist.add(token: token)
        }while token.getTokenType() != TokenType.END_DOCUMENT
    }

    
    func start() -> Token?{
        var ch = Character("\0")
        
        while(true){
            if !reader.hasMore(){
                return Token(tokenType: TokenType.END_DOCUMENT, value: "/0")
            }
            
            ch = reader.next()
            if !isWhiteSpace(ch){
                break;
            }
        }
        
        switch ch {
        case "{":
            return Token(tokenType: TokenType.BEGIN_OBJECT, value: String(ch))
        case "}":
            return Token(tokenType: TokenType.END_OBJECT, value: String(ch))
        case "[":
            return Token(tokenType: TokenType.BEGIN_ARRAY, value: String(ch))
        case "]":
            return Token(tokenType: TokenType.END_ARRAY, value: String(ch))
        case ",":
            return Token(tokenType: TokenType.SEP_COMMA, value: String(ch))
        case ":":
            return Token(tokenType: TokenType.SEP_COLON, value: String(ch))
        case "n":
            return readNull()
        case "t":
            return readBool()
        case "f":
            return readBool()
        case "\"":
            return readString()
        case "-":
            return readNumber()
        default:
            break
        }
        if isPurnInt(string: String(ch)){
            return readNumber()
        }
        print("Illegal Character")
        return nil      //nil means lexical analysis ERROR
    }
    //判断字符是否为空格/换行/Tab
    func isWhiteSpace(_ ch:Character) -> Bool{
        return (ch == " "||ch == "\t"||ch == "\r"||ch == "\n")
    }
    //判断字符是否为数字
    func isPurnInt(string: String) -> Bool {
        
        let scan: Scanner = Scanner(string: string)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
        
    }
    
    
    func readNull() -> Token{
        if !(reader.next()=="u"&&reader.next()=="l"&&reader.next()=="l"){
            print("Invalid Json Input")
            return Token()
        }
        else{
            return Token(tokenType: TokenType.NULL, value: "null")
        }
    }

    
    func readBool() -> Token{
        if reader.peek() == "t"{
            if !(reader.next()=="r"&&reader.next()=="u"&&reader.next()=="e"){
                print("unexpected Token")
                return Token()
            }
            else{
                return Token(tokenType: TokenType.BOOLEAN, value: "true")
            }
        }
        else{
            if !(reader.next()=="a"&&reader.next()=="l"&&reader.next()=="s"&&reader.next()=="e"){
               print("Invalid Json Input")
                return Token()
            }else{
                return Token(tokenType: TokenType.BOOLEAN, value: "false")
            }
        }
    }
    
    
    func readString() -> Token{
        var stringBuilder = ""
        
        while(true){
            var ch = reader.next()
            
            //转义字符
            if ch == "\\"{
                if (!isEscape()){
                    print("Invalid Escape Character")
                }
                
                stringBuilder.append("\\")
                ch = reader.peek()
                stringBuilder.append(ch)
                if(ch == "u"){      //处理 Unicode 编码
                    for _ in 0..<4{
                        ch = reader.next()
                        if isHex(ch){
                            stringBuilder.append(ch)
                        }else{
                            print("Invalid Unicode Character")
                        }
                    }
                }
                else if ch == "\""{
                    return Token(tokenType: TokenType.STRING, value: String(stringBuilder))
                }
                else if ch == "\r" || ch == "\n"{
                    print("Invalid line feed")
                }
                else{
                    stringBuilder.append(ch)
                }
            }
        }
    }
    //判断是否为乱传转义字符
    func isEscape() -> Bool{
        let ch = reader.next()
        return (ch == "\"" || ch == "\\" || ch == "u" || ch == "r"
            || ch == "n" || ch == "b" || ch == "t" || ch == "f" || ch == "/");
    }
    //判断是否为十六进制数
    func isHex(_ ch:Character) -> Bool{
        return ((ch >= "0" && ch <= "9")||("a" <= ch && ch <= "f")||("A" <= ch && ch <= "F"));
    }
    
  
    func readNumber() -> Token{
        var ch = reader.peek()
        var stringBuilder = ""
        
        if ch == "-"{   //处理负数
            stringBuilder.append(ch)
            ch = reader.next()
            if ch == "0"{   //-0.xxxxx
                stringBuilder.append(ch)
                stringBuilder = stringBuilder + readFracAndExp()
            }else if isDigit_1_9(ch){
                repeat{
                    stringBuilder.append(ch)
                    ch = reader.next()
                }while isDigit(ch)
//                if ch != nil{
//                    reader.back()
//                    stringBuilder.append(readFracAndExp())
//                }
            }else{
                print("Invalid minus number")
            }
        }else if ch == "0"{
            stringBuilder.append(ch)
            stringBuilder.append(readFracAndExp())
        }else{
            repeat{
                stringBuilder.append(ch)
                ch = reader.next()
            }while isDigit(ch)
//            if ch != (Char)-1{
//                reader.back()
//                stringBuilder.append(readFracAndExp())
//            }
        }
        return Token(tokenType: TokenType.NUMBER, value: stringBuilder)
    }
    //小数
    func readFracAndExp() -> String{
        var stringBilder = ""
        var ch = reader.next()
        if !isDigit(ch){
            print("Invalid frac")
        }
        if ch == "."{
        repeat{
            stringBilder.append(ch)
            ch = reader.next()
        }while isDigit(ch)
        
        //处理科学计数法表示的数字
        if isExp(ch){
            stringBilder.append(ch)
            stringBilder.append(readExp())
        }else{
//            if ch != (Char) - 1{
//                reader.back()
//            }
            }
        }else if isExp(ch){
            stringBilder.append(ch)
            stringBilder.append(readExp())
        }else{
            reader.back()
        }
        
        return stringBilder
    }
    //处理指数
    func readExp() -> String {
        var stringBuilder = ""
        var ch = reader.next()
        
        if ch == "+"||ch == "-"{
            stringBuilder.append(ch)
            ch = reader.next()
            
            if isDigit(ch){
                repeat{
                    stringBuilder.append(ch)
                    ch = reader.next()
                }while isDigit(ch)
                
                if ch == "\0"{
                    reader.back()
                }
            }else{
                print("e or E")
            }
        }else{
            print("e or E")
        }
        return stringBuilder
    }
    //判断是否为0-9
    func isDigit_1_9(_ ch:Character) -> Bool {
        return ch >= "1" && ch <= "9"
    }
    //判断是否为数字
    func isDigit(_ ch:Character) -> Bool {
        return ch >= "0" && ch <= "9"
    }
    func isExp(_ ch:Character) -> Bool {
        return ch == "e" || ch == "E"
    }
}
