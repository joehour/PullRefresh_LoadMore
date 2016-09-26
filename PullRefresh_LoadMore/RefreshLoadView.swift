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
    func refreshData(_ view: RefreshLoadView)
    func loadData(_ view: RefreshLoadView)
}

enum ActionState{
    
    case normal
    
    case topPull
    case pullRefresh
    case refreshing
    
    case bottomPull
    case loadMore
    case loading
    
}

open class RefreshLoadView: UIView{
    
    open var delegate :RefreshLoadViewDelegate?
    
    open var allObjectArray: NSMutableArray = []
    open var showElements: NSMutableArray = []
    
    open var pageItems: Int = 0
    open var nowItem: Int = 0
    
    var insertSize: CGFloat = 50
    var picWidth: CGFloat = 0
    var picHeight: CGFloat = 0
    
    var statusLabel: UILabel = UILabel()
    var activityView: UIActivityIndicatorView = UIActivityIndicatorView()
    var loadactivityView: UIActivityIndicatorView = UIActivityIndicatorView()
    var state: ActionState = ActionState.normal
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
        
        self.autoresizingMask = UIViewAutoresizing.flexibleWidth
        
        //Background Color
        //let background: UIView = UIView(frame: CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height))
        //background.backgroundColor = UIColor.lightGrayColor()
        //self.addSubview(background)
        
        arrowLayer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y-picWidth, width: picWidth, height: picHeight)
        let path = Bundle(for: RefreshLoadView.self).path(forResource: "arrow", ofType: "png")
        arrowLayer.contents = UIImage(contentsOfFile: path!)!.cgImage
        arrowLayer.contentsGravity = kCAGravityResizeAspect
        arrowLayer.contentsScale = UIScreen.main.scale
        arrowLayer.transform = CATransform3DRotate(arrowLayer.transform, CGFloat(M_PI), 0, 0, 1)
        self.layer.addSublayer(arrowLayer)
        
        let label: UILabel = UILabel(frame: CGRect(x: self.frame.origin.x+1.2*picWidth, y: self.frame.origin.y-picHeight, width: self.frame.size.width, height: picHeight))
        label.autoresizingMask = UIViewAutoresizing.flexibleWidth
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = UIColor.gray
        label.backgroundColor = UIColor.clear
        label.textAlignment = NSTextAlignment.left
        
        self.addSubview(label)
        statusLabel = label
        
        let view: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        view.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y-picHeight, width: picWidth, height: picHeight)
        self.addSubview(view)
        activityView = view
        activityView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        let active_view: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        self.addSubview(active_view)
        loadactivityView = active_view
        loadactivityView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        
        isrotate = true
        setState(.normal)
        
        self.isHidden = false
    }
    
    func animateCAlayer(_ layer: CALayer) {
        
        layer.isHidden = false
        CATransaction.begin()
        let animationDuration: TimeInterval = 0.5
        CATransaction.setAnimationDuration(animationDuration)
        CATransaction.setCompletionBlock {
            
            
        }
        
        
        layer.transform = CATransform3DRotate(layer.transform, CGFloat(M_PI), 0, 0, 1)
        CATransaction.commit()
        isrotate = false
    }
    
    
    func resetCAlayer(_ layer: CALayer, isrotate: Bool) {
        
        layer.isHidden = false
        if isrotate{
            layer.transform = CATransform3DRotate(layer.transform, CGFloat(-M_PI), 0, 0, 1)
        }
        
        
    }
    
    
    
    func setState(_ _state: ActionState) {
        switch _state {
            
        case .normal:
            statusLabel.text = NSLocalizedString("", comment: "")
            resetCAlayer(arrowLayer, isrotate: isrotate)
            activityView.stopAnimating()
            loadactivityView.stopAnimating()
            
            
        case .topPull:
            statusLabel.text = NSLocalizedString("", comment: "")
            
        case .pullRefresh:
            statusLabel.text = NSLocalizedString("", comment: "")
            animateCAlayer(arrowLayer)
            
        case .refreshing:
            statusLabel.text = NSLocalizedString("Refreshing...", comment: "")
            activityView.startAnimating()
            
        case .loading:
            statusLabel.text = NSLocalizedString("", comment: "")
            
        default:
            statusLabel.text = ""
        }
        state = _state
    }
    
    
    
    
    
    
    
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.isDragging {
            if state == .normal{
                if -scrollView.contentOffset.y > 0 {
                    setState(.topPull)
                    
                }
                
            }
            
            if state == .topPull || state == .loadMore{
                if -scrollView.contentOffset.y > insertSize {
                    setState(.pullRefresh)
                    
                    
                }
            }
            
            
            if state == .normal {
                if scrollView.contentOffset.y > (scrollView.contentSize.height - (scrollView.frame.size.height)) && scrollView.contentSize.height > 0 {
                    
                    setState(.bottomPull)
                    
                    
                }
            }
            
            
            if state == .bottomPull {
                if scrollView.contentOffset.y > 0 {
                    
                    UIView.animate(
                        withDuration: Double(1),
                        animations: {
                            
                            scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.insertSize, 0)
                            
                        },
                        completion: { finished in
                            
                            self.setState(.loadMore)
                        }
                    )
                }
                
            }
            
            
            
            if state == .loadMore {
                loadactivityView.startAnimating()
                self.loadactivityView.frame = CGRect(x: self.frame.origin.x, y: scrollView.contentSize.height, width: picWidth, height: picHeight)
                if delegate != nil {
                    delegate!.loadData(self)
                }
                setState(.loading)
            }
            
        }
        
        
    }
    
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView) {
        
        if state == .pullRefresh {
            if delegate != nil {
                
                DispatchQueue.main.async(execute: {
                    self.delegate!.refreshData(self)
                })
                
            }
            
            
            
            DispatchQueue.main.async(execute: {
                self.arrowLayer.isHidden = true
            })
            
            UIView.animate(
                withDuration: Double(0.2),
                animations: {
                    
                    scrollView.contentInset = UIEdgeInsetsMake(self.insertSize, 0, 0, 0)
                },
                completion: { finished in
                    
                    self.setState(ActionState.refreshing)
                }
            )
            
            
            
        }
        
        if state == .topPull {
            
            
            UIView.animate(
                withDuration: Double(0.1),
                animations: {
                    
                    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                },
                completion: { finished in
                    self.isrotate = false
                    self.setState(.normal)
                }
            )
            
            
            
        }
        
        
    }
    
    open func scrollViewDataSourceStartManualLoading(_ scrollView: UIScrollView) {
        
        UIView.animate(
            withDuration: Double(0.3),
            animations: {
                
                scrollView.contentInset = UIEdgeInsetsMake(self.insertSize, 0, 0, 0)
            },
            completion: { finished in
                
            }
        )
        
    }
    
    open func scrollViewFinishLoading(_ scrollView: UIScrollView) {
        
        
        UIView.animate(
            withDuration: Double(0.3),
            animations: {
                
                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            },
            completion: { finished in
                self.setState(.normal)
            }
        )
        
        
        
    }
    
    open func endRefresh(_ tableView: UITableView) {
        
        
        UIView.animate(
            withDuration: Double(0.3),
            animations: {
                
                tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            },
            completion: { finished in
                if self.state == .loadMore{
                    self.isrotate = false
                }
                else{
                    self.isrotate = true
                }
                
                if self.state != .normal{
                    self.setState(.normal)
                }
                
                self.showElements.removeAllObjects()
                self.nowItem = 0
                self.showElements.addObjects(from: self.allObjectArray.subarray(with: NSMakeRange(self.nowItem, self.pageItems)))
                tableView.reloadData()
                
            }
        )
        
        
        
    }
    
    
    
    open func endLoadMore(_ tableView: UITableView) {
        
        self.nowItem += self.pageItems
        if(self.nowItem < self.allObjectArray.count){
            self.showElements.addObjects(from: self.allObjectArray.subarray(with: NSMakeRange(self.nowItem, self.pageItems)))
            self.isrotate = false
            if self.state != .normal{
                self.setState(.normal)
            }
            
            
            tableView.reloadData()
        }
        else{
            
            UIView.animate(
                withDuration: Double(0.3),
                animations: {
                    
                    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
                },
                completion: { finished in
                    self.isrotate = false
                    if self.state != .normal{
                        self.setState(.normal)
                    }
                    
                    
                    tableView.reloadData()
                    
                }
            )
        }
        
        
        
        
        
        
        
    }
    
    open func setData(_ Data: NSMutableArray){
        allObjectArray = Data
        if(self.pageItems > self.allObjectArray.count){
            self.pageItems = self.allObjectArray.count
        }
        showElements.addObjects(from: self.allObjectArray.subarray(with: NSMakeRange(self.nowItem, self.pageItems)))
   }
}
