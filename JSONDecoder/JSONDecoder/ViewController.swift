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
    
//    let jsonparser = JsonParser()
    
    @IBOutlet weak var jsonTarget: UITextField!
    @IBOutlet weak var jsonResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func sendGetRequest(_ sender: UIButton) {
        let urlString:String = jsonTarget.text!
        
        print("gonna SEND🤞")
        Alamofire.request(urlString).responseJSON
            { response in
                if let json = response.result.value
                {
                    print("JSON: \(json)")
                    self.jsonResult.text = json as? String
                }

        }
        
}

}
