//
//  DetailedViewController.swift
//  BOBOResource
//
//  Created by 杜波 on 16/10/24.
//  Copyright © 2016年 杜波. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webview: UIWebView!
    var url:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let test:UITextField?=nil
        
        
        self.webview.loadRequest(NSURLRequest(url:NSURL(string:(test?.text!)!) as! URL)as URLRequest)
//        let url = NSURL(string: self.url)
//        
//        let request = NSURLRequest(url: url! as URL)
//        self.webview.loadRequest(request as URLRequest)
        
        self.webview.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
