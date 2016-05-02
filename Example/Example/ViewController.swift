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
            allObjectArray.addObject(i.description)
        }
        
        //Initial
        refreshloadView  = RefreshLoadView(frame: CGRectMake(95, 0, table_view.frame.width, table_view.frame.height), pic_size: CGFloat(30), insert_size: CGFloat(50))
        
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
    
    func refreshData(view: RefreshLoadView) {
        
        //refresh data
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            sleep(1)
            dispatch_async(dispatch_get_main_queue(), {
                
                //end refresh
                self.refreshloadView.endRefresh(self.table_view)
            });
        });
        
    }
    
    
    
    func loadData(view: RefreshLoadView) {
        
        //load more data
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            sleep(1)
            dispatch_async(dispatch_get_main_queue(), {
                
                //end load more
                self.refreshloadView.endLoadMore(self.table_view)
            });
        });
        
    }
    
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int)
        -> Int {
            if refreshloadView != nil {
                return refreshloadView.showElements.count
            }
            else{
                return 0
                
            }
            
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.navigationBar.hidden = false
        self.view.layoutIfNeeded()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    ////show cell
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
            if !(cell != nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
            }
            
            if refreshloadView != nil {
                cell!.textLabel!.text = refreshloadView.showElements[indexPath.row] as? String
            }
            
            return cell
            
            
            
    }
    
    //scroll event
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        refreshloadView.scrollViewDidScroll(scrollView)
        
    }
    
    //scroll event
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        refreshloadView.scrollViewDidEndDragging(scrollView)
    }

}

