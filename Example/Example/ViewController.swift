//
//  ViewController.swift
//  Example
//
//  Created by JoeJoe on 2016/4/29.
//  Copyright © 2016年 JoeJoe. All rights reserved.
//

import UIKit
import PullRefresh_LoadMore

class ViewController: UIViewController, RefreshLoadViewDelegate {

    @IBOutlet weak var table_view: UITableView!
    
    var refreshloadView: RefreshLoadView!
    var allObjectArray: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add Test Data
        for i in 1...(100) {
            allObjectArray.add(i.description)
        }
        
        //Initial
        refreshloadView  = RefreshLoadView(frame: CGRect(x: 95, y: 0, width: table_view.frame.width, height: table_view.frame.height), pic_size: CGFloat(30), insert_size: CGFloat(50))
        
        //have 25 item on each page
        refreshloadView.pageItems = 25
        
        //set Data
        refreshloadView.setData(allObjectArray)
        refreshloadView.delegate = self
        
        //add RefreshLoadView to tableView
        table_view.addSubview(refreshloadView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(_ view: RefreshLoadView) {
        
        //refresh data
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            
            sleep(1)
            DispatchQueue.main.async(execute: {
                
                //end refresh
                self.refreshloadView.endRefresh(self.table_view)
            });
        });
        
    }
    
    
    
    func loadData(_ view: RefreshLoadView) {
        
        //load more data
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
            sleep(1)
            DispatchQueue.main.async(execute: {
                
                //end load more
                self.refreshloadView.endLoadMore(self.table_view)
            });
        });
        
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int)
        -> Int {
            if refreshloadView != nil {
                return refreshloadView.showElements.count
            }
            else{
                return 0
                
            }
            
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.isHidden = false
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    ////show cell
    func tableView(_ tableView: UITableView,
                   cellForRowAtIndexPath indexPath: IndexPath)
        -> UITableViewCell {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
            if !(cell != nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
            }
            
            if refreshloadView != nil {
                cell!.textLabel!.text = refreshloadView.showElements[indexPath.row] as? String
            }
            
            return cell!
            
            
            
    }
    
    //scroll event
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        refreshloadView.scrollViewDidScroll(scrollView)
        
    }
    
    //scroll event
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        refreshloadView.scrollViewDidEndDragging(scrollView)
    }

}

