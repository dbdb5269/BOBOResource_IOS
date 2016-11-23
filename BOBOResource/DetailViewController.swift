//
//  DetailViewController.swift
//  BOBOResource
//
//  Created by 杜波 on 16/9/29.
//  Copyright © 2016年 杜波. All rights reserved.
//

import UIKit
import SwiftyJSON
import Reachability

class DetailViewController: UITableViewController,UIAlertViewDelegate,NSURLConnectionDataDelegate{
    
    var reachability: Reachability!
    var jsonData:NSData?
    var id:String!
    var conn:NSURLConnection!
    var url: String!//NSString改为String
    var signal:Bool=false
    lazy var courseList:[String]=[String]()
    lazy var listTeams :[String]=[String]()
    //var listFilterTeams:NSMutableArray!
    var jsonFile : NSData!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBAction func refresh(_ sender: UIRefreshControl) {
        courseList.removeAll()
        listTeams.removeAll()
        loadurl()
        
        sender.endRefreshing()
        self.tableView.reloadData()
        
    }
    

    func loadurl(){
        let APIURL="http://www.mrdubo.com/api.php"+"/?id=\(id!)"
        let url=URL(string: APIURL)

        //创建请求对象
        let urlRequest:NSURLRequest = NSURLRequest(url: url!)
        let ur:NSURLRequest=NSURLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData , timeoutInterval: 5)
        //响应对象
        var response:URLResponse?
        
        do{
            //发送请求
            let jsonData:NSData? = try NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest,returning: &response) as NSData?
            
            if jsonData==nil {
                print("error")
                exit(-1)
            }
            
            
            let json=JSON(data:jsonData as! Data)
            
            
            let jsoncount=json["CourseName"].count
            
            var courseName=(json["CourseName"].string)
            let length = courseName?.characters.count;
            
            if(jsoncount==0 && length==nil){
                
                listTeams=courseList
                
            }
            else if(jsoncount==0 && length!>0){
                
                self.courseList.append(courseName!)
                listTeams=courseList
            }else{
                
                for index in 0 ..< jsoncount{
                    
                    let courseName:String=(json["CourseName"][index].string)!
                    self.courseList.append(courseName)
                }
                self.listTeams=self.courseList
                
                
            }

            
            
            
        }catch let error as NSError{
            //打印错误消息
                    var alterView = UIAlertController()
                    alterView.title="Network"
                    alterView.message="Network not allowed"
                    var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
                    alterView.addAction(cancelAction)
                    self.present(alterView,animated: true, completion: nil)
        }
    }
    
    
//    func testNetwork(){
//        let urlPath: String = "http://www..com/api.php"
//        let url: NSURL = NSURL(string: urlPath)!
//        let request: NSURLRequest = NSURLRequest(url: url as URL)
//        
//        conn = NSURLConnection(request: request as URLRequest, delegate: self)!
//        conn.start()
//        print("start")
//    }
//    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
//        print("接收到服务器的数据")
//        //拼接数据
//        
//    }
//    func connectionDidFinishLoading(_ connection: NSURLConnection) {
//        print("服务器的数据加载完毕")
//        signal=true
//        loadurl()
//        
//    }
//
//    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
//        print("error")
//       
//        var alterView = UIAlertController()
//        alterView.title="Network"
//        alterView.message="Network not allowed"
//        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
//        alterView.addAction(cancelAction)
//        self.present(alterView,animated: true, completion: nil)
//        
//    }
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        loadurl()
        
        
        
//        Alamofire.request("http://www.mrdubo.com/api/api.php")
        
//        if siganol==2{
//            
//        }else{
//            var alterView = UIAlertController()
//            alterView.title="Network"
//            alterView.message="Network not allowed"
//            var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
//            alterView.addAction(cancelAction)
//            self.present(alterView,animated: true, completion: nil)
//        }
        
//        let reachability = Reachability()!
//
//        do{
//            try reachability.startNotifier()
//        }catch{
//            print("could not start reachability notifier")
//        }
//        if reachability.isReachable {
//            self.loadurl()
//        }else{
//
//            var alterView = UIAlertController()
//            alterView.title="Network"
//            alterView.message="Network not allowed"
//            var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
//            alterView.addAction(cancelAction)
//            self.present(alterView,animated: true, completion: nil)
//            
//            
//            
//        }
        
        
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTeams.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellIdentifier"
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath)
        let row = indexPath.row
        
        cell.textLabel?.text=self.listTeams[row] as? String
        
        //cell.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="ShowDetailed"){
            let detailViewedController = segue.destination as! DetailedViewController
            let indexPath = self.tableView.indexPathForSelectedRow as NSIndexPath?
            let selectedIndex = indexPath!.row
            let APIURL="http://www.mrdubo.com/api.php"+"/?id=\(id!)"
 //           let APIURL="http://localhost/~dubo/api/api.php?id=\(id!)"
            let url=NSURL(string: APIURL)
            jsonData=NSData(contentsOf: url as! URL)
            let json=JSON(data:jsonData as! Data)
    
            let jsoncount:Int=json["CourseName"].count
            if(jsoncount==0){
                 detailViewedController.url=(json["url"].string)!
            }else{
                detailViewedController.url = (json["url"][selectedIndex].string)!
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UIWebViewDelegate委托定义方法
    //    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    //
    //    }
    //    //UIWebViewDelegate委托定义方法
    //    func webViewDidFinishLoad(webView: UIWebView) {
    //        NSLog("finish")
    //    }
    
}
