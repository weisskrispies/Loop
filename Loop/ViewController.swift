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

    var newsStoriesByCategory: [String: [PFObject]]! = [String: [PFObject]]()

    var timer: NSTimer!
    
    var currentHeadlineRow: Int = 0
    
    var categories = ["NEED TO KNOW", "LOCAL", "TECH + DESIGN", "HOSPITALITY", "FROM YOUR FRIENDS"]
    
    
    let prefs = NSUserDefaults.standardUserDefaults()
    
    var darkBlueColor = UIColor(red: 11/255, green: 29/255, blue: 41/255, alpha: 1.0)
    var lighterBlueColor = UIColor(red: 6/255, green: 43/255, blue: 69/255, alpha: 1.0)
    var darkRedColor = UIColor(red: 50/255, green: 7/255, blue: 7/255, alpha: 1.0)
    var lighterRedColor = UIColor(red: 82/255, green: 1/255, blue: 0/255, alpha: 1.0)
    var yellowColor = UIColor(red: 69/255, green: 69/255, blue: 12/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("times openened: \(launchCount)")
        
        let today = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        
        // querries the parse database for content and populates the table
        let query = PFQuery(className: "Headlines")
        
        // scans for only stories in Parse with today's date
        query.whereKey("headline_date", greaterThan: today)

        
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
        
//        currentHeadlineRow = indexPath.row
//        print ("current headline row: \(indexPath.row)")
        
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
        headlineLabel.textColor = UIColor.blackColor()
        headerView.backgroundColor = UIColor.whiteColor()
        headerView.alpha = 0.5
        headerView.addSubview(headlineLabel)
        
        return headerView
    }
    
    // sets the row height to full screen
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if (indexPath.row != 0) {
//            return UIScreen.mainScreen().bounds.height
//        }
//        return UIScreen.mainScreen().bounds.height - self.tableView.sectionHeaderHeight
//    }
    
    // set the header height
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let categoryName = categories[section]
        let newsStories = newsStoriesByCategory[categoryName]
        if newsStories == nil || newsStories?.count == 0 {
            return 0
        }
        
        return 40
    }


    
    //assigns the background color to each section 
    func backgroundColorForSection(sectionIndex: Int) -> UIColor {

        switch sectionIndex {
        case 0: return darkBlueColor
        case 1: return lighterBlueColor
        case 2: return darkRedColor
        case 3: return lighterRedColor
        case 4: return lighterRedColor
        default: return darkBlueColor
        }
    }

    
//    func patrickIsAwesome() {
//        tableViewScrollToNext(true)
//    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }


}

