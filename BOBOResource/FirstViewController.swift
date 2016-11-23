//
//  FirstViewController.swift
//  BOBOResource
//
//  Created by 杜波 on 16/9/25.
//  Copyright © 2016年 杜波. All rights reserved.
//

import UIKit
import SwiftyJSON
class FirstViewController: UITableViewController,UISearchBarDelegate{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var courseList:[String]=[String]()
    var listTeams : NSArray!
    var listFilterTeams:NSMutableArray!
    var jsonFile : NSData!
    
    func load(){
        let plistPath = Bundle.main.path(forResource: "Demo", ofType: "json")
        self.jsonFile = NSData(contentsOfFile: plistPath!)
        let json=JSON(data:jsonFile as Data)
        let jsoncount:Int=json["Course"].count
        
        
        for index in 0 ..< jsoncount{
            let jsonDictionary=json["Course"][index].dictionary
            var courseName:String=(jsonDictionary!["CourseName"]?.string)!
            self.courseList.append(courseName)
        }
        listTeams=courseList as NSArray
        
        
        
        
        self.filterContentForSearchText(searchText: "", scope:-1)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate=self
        self.searchBar.showsScopeBar=false
        self.searchBar.sizeToFit()
        load()
        // Do any additional setup after loading the view.
        
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //过滤结果集方法
    func filterContentForSearchText(searchText: NSString, scope: Int) {
        if(searchText.length == 0) {
            //查询所有
            self.listFilterTeams = NSMutableArray(array: self.listTeams)
            return
        }
        var tempArray : NSArray!
        
        if (scope == 1) { //中文 name字段是中文名
            let scopePredicate = NSPredicate(format:"SELF contains[c] %@", searchText)
            //print("scope=1")
            tempArray = self.listTeams.filtered(using: scopePredicate) as NSArray//删除!
            
            self.listFilterTeams = NSMutableArray(array: tempArray)
            
        } else {                //查询所有
            self.listFilterTeams = NSMutableArray(array: self.listTeams)
        }
    }
    ///UITableViewDataSource 协议方法
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listFilterTeams.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:indexPath as IndexPath)
        let row = indexPath.row
        
        cell.textLabel?.text=self.listFilterTeams[row] as? String
        
        //cell.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell:UITableViewCell=tableView.cellForRow(at: indexPath)!
//        if(cell.accessoryType==UITableViewCellAccessoryType.none){
//            cell.accessoryType = UITableViewCellAccessoryType.checkmark
//        }else{
//            cell.accessoryType = UITableViewCellAccessoryType.none
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="ShowDetail"){
            let detailViewController = segue.destination as! DetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow as NSIndexPath?
            let selectedIndex = indexPath!.row
            let plistPath = Bundle.main.path(forResource: "Demo", ofType: "json")
            self.jsonFile = NSData(contentsOfFile: plistPath!)
            let json=JSON(data:jsonFile as Data)
            let jsonDictionary=json["Course"][selectedIndex].dictionary
            detailViewController.id = (jsonDictionary!["id"]?.string)!
            //detailViewController.url = (jsonDictionary!["URL"]?.string)!
        }
    }
    /// 实现 UISearchBarDelegate 协议方法
    //  获得焦点，成为第一响应者
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.searchBar.showsScopeBar = true
        self.searchBar.sizeToFit()
        return true
    }
    
    //点击键盘上的搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsScopeBar = false
        self.searchBar.resignFirstResponder()
        self.searchBar.sizeToFit()
    }
    //点击搜索栏取消按钮
    func searchBarCancelButtonClicked(_ searchBar : UISearchBar) {
        //查询所有
        self.filterContentForSearchText(searchText: "", scope:-1)
        self.searchBar.showsScopeBar = false
        self.searchBar.resignFirstResponder()
        self.searchBar.sizeToFit()
    }
    
    //当文本内容发生改变时候调用
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText2: String) {
        //print(searchText2)
        self.filterContentForSearchText(searchText: searchText2 as NSString, scope:1)
        
        // print("filter")
        self.tableView.reloadData()
        // print("reload")
    }
    
    //当搜索范围选择发生变化时候调用
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContentForSearchText(searchText: self.searchBar.text! as NSString, scope:selectedScope)
        self.tableView.reloadData()
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
