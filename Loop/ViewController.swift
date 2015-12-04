    //
//  ViewController.swift
//  Loop
//
//  Created by Patrick Weiss on 10/20/15.
//  Copyright © 2015 Patrick Weiss. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var landingScreenImage: UIImageView!
    @IBOutlet weak var hitHintDotImage: UIImageView!
    @IBOutlet weak var hitHintCircleImage: UIImageView!
    
    
    var newsStoriesByCategory: [String: [PFObject]]! = [String: [PFObject]]()

    var timer: NSTimer!
    
    var currentHeadlineRow: Int = 0
    
    var categories = ["NEED TO KNOW", "LOCAL", "TECH + DESIGN", "HOSPITALITY", "FROM YOUR FRIENDS"]
    
    var darkPurpleColor = UIColor(red: 109/255, green: 67/255, blue: 120/255, alpha: 1.0)
    var lightPurpleColor = UIColor(red: 132/255, green: 96/255, blue: 140/255, alpha: 1.0)
    var lightTurquoise = UIColor(red: 53/255, green: 166/255, blue: 165/255, alpha: 1.0)
    var darkTurquoise = UIColor(red: 36/255, green: 110/255, blue: 139/255, alpha: 1.0)
    var darkBlue = UIColor(red: 60/255, green: 62/255, blue: 112/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        
//        for view in tableView.subviews {
//            if view.isKindOfClass(UIScrollView) {
//                view.addGestureRecognizer(onLongPress)
//            }
//        }
        
        // querries the parse database for content and populates the table
        let query = PFQuery(className: "Headlines")
        
        // scans for only stories in Parse with today's date
//        query.whereKey("headline_date", greaterThan: today)

        
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if results == nil {
                return
            }
            
            for newsStory in results! {
                var category = newsStory["Category"] as? String
                
                if category != nil {
                    category = category?.uppercaseString
                    
                    var newsStories = self.newsStoriesByCategory[category!]
                    
                    if newsStories == nil {
                        newsStories = []
                    }
                    newsStories!.append(newsStory)
                    
                    self.newsStoriesByCategory[category!] = newsStories
                    
                    print("newsStories: \(newsStories)")
                    print("class newsStories: \(self.newsStoriesByCategory[category!])")
                }
            }
            self.tableView.reloadData()
            
        }
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: [UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.Repeat], animations: { () -> Void in
            self.hitHintCircleImage.transform = CGAffineTransformMakeScale(1.3, 1.3)
            }) { (Bool) -> Void in
        }
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // sets the number of sections to the number of headlines
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryName = categories[section]
        
        let newsStories = newsStoriesByCategory[categoryName]
        
        if newsStories != nil {
            return newsStories!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        print("Row: \(indexPath.row), Section: \(indexPath.section)")
        print ("row height: \(tableView.rowHeight)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HeadlineCell") as! HeadlineCell
        
        let categoryName = categories[indexPath.section]
        
        let newsStories = newsStoriesByCategory[categoryName]!
        let newsStory = newsStories[indexPath.row]
        let headline = newsStory["Headline"] as? String
        
        cell.headlineLabel.text = headline
        
        //update to assign
        cell.backgroundColor = backgroundColorForSection(indexPath.section)
        
        currentHeadlineRow = indexPath.row
        print ("current headline row: \(indexPath.row)")
        
        return cell
    }
    
    // creates and sets the header's content and aesthetic
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let categoryName = categories[section]
        let newsStories = newsStoriesByCategory[categoryName]
        if newsStories == nil || newsStories?.count == 0 {
            return nil
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let headlineLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 40))
        
        headlineLabel.text = categoryName
        headlineLabel.textColor = UIColor.whiteColor()
        headerView.backgroundColor = UIColor.clearColor()
        headerView.addSubview(headlineLabel)
        
        return headerView
    }
    
    // sets the row height to full screen
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row != 0) {
            return UIScreen.mainScreen().bounds.height
        }
        return UIScreen.mainScreen().bounds.height - self.tableView.sectionHeaderHeight
    }
    
    // set the header height
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let categoryName = categories[section]
        let newsStories = newsStoriesByCategory[categoryName]
        if newsStories == nil || newsStories?.count == 0 {
            return 0
        }
        
        return 40
    }

    @IBAction func onLongPress(sender: UILongPressGestureRecognizer) {
        
//        let state: UIGestureRecognizerState = gesture.state
//        let location: CGPoint = gesture.locationInView(tableView)
//        let indexPath: NSIndexPath? = tableView.indexPathForRowAtPoint(location)
        
        print("did recognize long press")

        if sender.state == UIGestureRecognizerState.Began {
            UIView.animateWithDuration(0.6, animations: { () -> Void in
                self.landingScreenImage.alpha = 0
                self.hitHintCircleImage.alpha = 0
                self.hitHintDotImage.alpha = 0
                self.landingScreenImage.frame.origin.y = 568
                
                }) { (Bool) -> Void in
                    
                    self.delay(2.0, closure: { () -> () in
                        
                    
                    //insert if statement that says 'if headline count < total number, otherwise, segue
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "patrickIsAwesome", userInfo: nil, repeats: true)
                        self.timer.fire()
                        
                    })
            }
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
//            timer.invalidate()
        }
        
    }
    
    //assigns the background color to each section 
    func backgroundColorForSection(sectionIndex: Int) -> UIColor {

        switch sectionIndex {
        case 0: return darkPurpleColor
        case 1: return lightPurpleColor
        case 2: return lightTurquoise
        case 3: return darkTurquoise
        case 4: return darkBlue
        default: return darkPurpleColor
        }
    }

    
    func patrickIsAwesome() {
        tableViewScrollToNext(true)
    }
    
    func tableViewScrollToNext(animated: Bool) {
        
        print("scrolling to next")
        
        //create array of NSIndex path and jump to
        
        let indexPath = NSIndexPath(forRow: self.currentHeadlineRow+1, inSection: 0)
        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: animated)
//        })
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }


}

