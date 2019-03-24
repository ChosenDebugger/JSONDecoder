//
//  ViewController.swift
//  JSONDecoder
//
//  Created by 齐旭晨 on 2019/3/15.
//  Copyright © 2019 齐旭晨. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var jsonTarget: UITextField!
    @IBOutlet weak var jsonResult: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendGetRequest(_ sender: UIButton) {
        
        let jsontarget = jsonTarget.text
        var jsonresultStr = ""

        if jsontarget == ""{
            print("Please input the target Json-url")
            return
        }
        
        let url:URL! = URL(string: jsontarget!);
        let urlRequest:URLRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        var response:URLResponse?
        
        do {
            let received =  try NSURLConnection.sendSynchronousRequest(urlRequest, returning: &response)
            let dic = try JSONSerialization.jsonObject(with: received, options: JSONSerialization.ReadingOptions.allowFragments)
            print(dic)
            
            jsonresultStr = String(data: received, encoding:String.Encoding.utf8)!;
        } catch let error{
            print(error.localizedDescription);
        }
        
        let jsonparser = JsonParser()
        let jsonresult = (jsonparser.main_parser(jsonresultStr)) as! JsonObject
        
        if jsonresult.isEmpty(){
            jsonResult.text = "Nothing"
        }
        
        jsonResult.text = jsonresult.toString()
        
    }
}
