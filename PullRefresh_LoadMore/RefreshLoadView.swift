//
//  RefreshLoadView.swift
//  PullRefresh_LoadMore
//
//  Created by JoeJoe on 2016/4/28.
//  Copyright © 2016年 JoeJoe. All rights reserved.
//

import Foundation
import UIKit


public protocol RefreshLoadViewDelegate {
    func refreshData(view: RefreshLoadView)
    func loadData(view: RefreshLoadView)
}

enum ActionState{
    
    case Normal
    
    case TopPull
    case PullRefresh
    case Refreshing
    
    case BottomPull
    case LoadMore
    case Loading
    
}

public class RefreshLoadView: UIView{
    
    public var delegate :RefreshLoadViewDelegate?
    
    public var allObjectArray: NSMutableArray = []
    public var showElements: NSMutableArray = []
    
    public var pageItems: Int = 0
    public var nowItem: Int = 0
    
    var insertSize: CGFloat = 50
    var picWidth: CGFloat = 0
    var picHeight: CGFloat = 0
    
    var statusLabel: UILabel = UILabel()
    var activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadactivityView: UIActivityIndicatorView = UIActivityIndicatorView()
    var state: ActionState = ActionState.Normal
    var arrowLayer: CALayer = CALayer()
    var isrotate: Bool = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.Init()
    }
    
    public init(frame: CGRect, pic_size: CGFloat, insert_size: CGFloat) {
        super.init(frame: frame)
        picWidth = pic_size
        picHeight = pic_size
        insertSize = insert_size
        self.Init()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func Init(){
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        
        //Background Color
        //let background: UIView = UIView(frame: CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height))
        //background.backgroundColor = UIColor.lightGrayColor()
        //self.addSubview(background)
        
        arrowLayer.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-picWidth, picWidth, picHeight)
        let path = NSBundle(forClass: RefreshLoadView.self).pathForResource("arrow", ofType: "png")
        arrowLayer.contents = UIImage(contentsOfFile: path!)!.CGImage
        arrowLayer.contentsGravity = kCAGravityResizeAspect
        arrowLayer.contentsScale = UIScreen.mainScreen().scale
        arrowLayer.transform = CATransform3DRotate(arrowLayer.transform, CGFloat(M_PI), 0, 0, 1)
        self.layer.addSublayer(arrowLayer)
        
        let label: UILabel = UILabel(frame: CGRectMake(self.frame.origin.x+1.2*picWidth, self.frame.origin.y-picHeight, self.frame.size.width, picHeight))
        label.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        label.font = UIFont.boldSystemFontOfSize(13)
        label.textColor = UIColor.grayColor()
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = NSTextAlignment.Left
        
        self.addSubview(label)
        statusLabel = label
        
        let view: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        view.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-picHeight, picWidth, picHeight)
        self.addSubview(view)
        activityView = view
        activityView.transform = CGAffineTransformMakeScale(1.5, 1.5)
        
        let active_view: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        
        self.addSubview(active_view)
        loadactivityView = active_view
        loadactivityView.transform = CGAffineTransformMakeScale(1.5, 1.5)
        
        isrotate = true
        setState(.Normal)
        
        self.hidden = false
    }
    
    func animateCAlayer(layer: CALayer) {
        
        layer.hidden = false
        CATransaction.begin()
        let animationDuration: NSTimeInterval = 0.5
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            
            
        }
        
        
        layer.transform = CATransform3DRotate(layer.transform, CGFloat(M_PI), 0, 0, 1)
        CATransaction.commit()
        isrotate = false
    }
    
    
    func resetCAlayer(layer: CALayer, isrotate: Bool) {
        
        layer.hidden = false
        if isrotate{
            layer.transform = CATransform3DRotate(layer.transform, CGFloat(-M_PI), 0, 0, 1)
        }
        
        
    }
    
    
    
    func setState(_state: ActionState) {
        switch _state {
            
        case .Normal:
            statusLabel.text = NSLocalizedString("", comment: "")
            resetCAlayer(arrowLayer, isrotate: isrotate)
            activityView.stopAnimating()
            loadactivityView.stopAnimating()
            
            
        case .TopPull:
            statusLabel.text = NSLocalizedString("", comment: "")
            
        case .PullRefresh:
            statusLabel.text = NSLocalizedString("", comment: "")
            animateCAlayer(arrowLayer)
            
        case .Refreshing:
            statusLabel.text = NSLocalizedString("Refreshing...", comment: "")
            activityView.startAnimating()
            
        case .Loading:
            statusLabel.text = NSLocalizedString("", comment: "")
            
        default:
            statusLabel.text = ""
        }
        state = _state
    }
    
    
    
    
    
    
    
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.dragging {
            if state == .Normal{
                if -scrollView.contentOffset.y > 0 {
                    setState(.TopPull)
                    
                }
                
            }
            
            if state == .TopPull || state == .LoadMore{
                if -scrollView.contentOffset.y > insertSize {
                    setState(.PullRefresh)
                    
                    
                }
            }
            
            
            if state == .Normal {
                if scrollView.contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height)) && scrollView.contentSize.height > 0 {
                    
                    setState(.BottomPull)
                    
                    
                }
            }
            
            
            if state == .BottomPull {
                if scrollView.contentOffset.y > 0 {
                    
                    UIView.animateWithDuration(
                        Double(1),
                        animations: {
                            
                            scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.insertSize, 0)
                            
                        },
                        completion: { finished in
                            
                            self.setState(.LoadMore)
                        }
                    )
                }
                
            }
            
            
            
            if state == .LoadMore {
                loadactivityView.startAnimating()
                self.loadactivityView.frame = CGRectMake(self.frame.origin.x, scrollView.contentSize.height, picWidth, picHeight)
                if delegate != nil {
                    delegate!.loadData(self)
                }
                setState(.Loading)
            }
            
        }
        
        
    }
    
    
    public func scrollViewDidEndDragging(scrollView: UIScrollView) {
        
        if state == .PullRefresh {
            if delegate != nil {
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.delegate!.refreshData(self)
                })
                
            }
            
            
            
            dispatch_async(dispatch_get_main_queue(),{
                self.arrowLayer.hidden = true
            })
            
            UIView.animateWithDuration(
                Double(0.2),
                animations: {
                    
                    scrollView.contentInset = UIEdgeInsetsMake(self.insertSize, 0, 0, 0)
                },
                completion: { finished in
                    
                    self.setState(ActionState.Refreshing)
                }
            )
            
            
            
        }
        
        if state == .TopPull {
            
            
            UIView.animateWithDuration(
                Double(0.1),
                animations: {
                    
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                },
                completion: { finished in
                    self.isrotate = false
                    self.setState(.Normal)
                }
            )
            
            
            
        }
        
        
    }
    
    public func scrollViewDataSourceStartManualLoading(scrollView: UIScrollView) {
        
        UIView.animateWithDuration(
            Double(0.3),
            animations: {
                
                scrollView.contentInset = UIEdgeInsetsMake(self.insertSize, 0, 0, 0)
            },
            completion: { finished in
                
            }
        )
        
    }
    
    public func scrollViewFinishLoading(scrollView: UIScrollView) {
        
        
        UIView.animateWithDuration(
            Double(0.3),
            animations: {
                
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            },
            completion: { finished in
                self.setState(.Normal)
            }
        )
        
        
        
    }
    
    public func endRefresh(tableView: UITableView) {
        
        
        UIView.animateWithDuration(
            Double(0.3),
            animations: {
                
                tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            },
            completion: { finished in
                if self.state == .LoadMore{
                    self.isrotate = false
                }
                else{
                    self.isrotate = true
                }
                
                if self.state != .Normal{
                    self.setState(.Normal)
                }
                
                self.showElements.removeAllObjects()
                self.nowItem = 0
                self.showElements.addObjectsFromArray(self.allObjectArray.subarrayWithRange(NSMakeRange(self.nowItem, self.pageItems)))
                tableView.reloadData()
                
            }
        )
        
        
        
    }
    
    
    
    public func endLoadMore(tableView: UITableView) {
        
        self.nowItem += self.pageItems
        if(self.nowItem < self.allObjectArray.count){
            self.showElements.addObjectsFromArray(self.allObjectArray.subarrayWithRange(NSMakeRange(self.nowItem, self.pageItems)))
            self.isrotate = false
            if self.state != .Normal{
                self.setState(.Normal)
            }
            
            
            tableView.reloadData()
        }
        else{
            
            UIView.animateWithDuration(
                Double(0.3),
                animations: {
                    
                    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                },
                completion: { finished in
                    self.isrotate = false
                    if self.state != .Normal{
                        self.setState(.Normal)
                    }
                    
                    
                    tableView.reloadData()
                    
                }
            )
        }
        
        
        
        
        
        
        
    }
    
    public func setData(Data: NSMutableArray){
        allObjectArray = Data
        if(self.pageItems > self.allObjectArray.count){
            self.pageItems = self.allObjectArray.count
        }
        showElements.addObjectsFromArray(self.allObjectArray.subarrayWithRange(NSMakeRange(self.nowItem, self.pageItems)))
   }
}