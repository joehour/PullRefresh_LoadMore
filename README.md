# PullRefresh_LoadMore
#### A PullRefresh and LoadMore TableView on iOS(swift).

<img src="https://raw.githubusercontent.com/joehour/PullRefresh_LoadMore/master/example1.gif"  />  <img src="https://raw.githubusercontent.com/joehour/PullRefresh_LoadMore/master/example2.gif"  />

## Installation

#### CocoaPods

Check out [Get Started](https://guides.cocoapods.org/using/getting-started.html) tab on [cocoapods.org](http://cocoapods.org/).

To use PullRefresh_LoadMore in your project add the following 'Podfile' to your project

	source 'https://github.com/joehour/PullRefresh_LoadMore.git'
	platform :ios, '8.0'
	use_frameworks!

	pod 'PullRefresh_LoadMore', '~> 1.0.1'

Then run:

    pod install
##Example

####Please check out the Example project included.
   
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
    
    //refresh data
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
    
    
    //load more data 
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
    
##Requirements

- iOS 8.0 or later
- Swift 2.2 or higher
- Xcode 7.3 or higher
    
##License
PullRefresh_LoadMore is available under the MIT License.

Copyright © 2016 Joe.
