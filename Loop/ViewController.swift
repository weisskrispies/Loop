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
    
    var headlines = ["Square files for much-anticipated IPO", "Hurricane Joaquin headed for eastern US this weekend", "Steve Ballmer now owns 4% of Twitter", "San Francisco passes law to eliminate sales tax by 2020", "California records warmest October in past 200 years", "Marina man wanted for arson arrested", "Tinder parent company files for IPO in November", "Elon Musk shows off first working Hyperloop prototype", "Couch Surfing announces partnership with Hyatt & Marriott Hotels", "Kate Montgomery has a new job at Lendable"]
    
    var categories = ["NEED TO KNOW", "NEED TO KNOW", "NEED TO KNOW", "LOCAL", "LOCAL", "LOCAL", "TECH + DESIGN", "TECH + DESIGN", "HOSPITALITY", "FROM YOUR FRIENDS"]
    
    var lightPurpleColor = UIColor(red: 132/255, green: 96/255, blue: 140/255, alpha: 1.0)
    var darkPurpleColor = UIColor(red: 109/255, green: 67/255, blue: 120/255, alpha: 1.0)
    
    // Instantiate long press gesture
    let longPress: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer()
        return recognizer
        }()
    
    var timer: NSTimer!
    
    var currentHeadlineRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let numberOfSections = tableView.numberOfSections
        let numberOfRowsInSection = tableView.numberOfRowsInSection(numberOfSections-1)
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        print("Row: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Headline Cell") as! HeadlineCell
        
        cell.headlineLabel.text = headlines[indexPath.row]
        cell.backgroundColor = lightPurpleColor

        currentHeadlineRow = indexPath.row
        
        return cell
    }
    
    // sets the number of sections to the number of headlines
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return headlines.count
    }
    
    // creates and sets the header's content and aesthetic
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let headlineLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 300, height: 40))
        
        headlineLabel.text = categories[0]
        headlineLabel.textColor = UIColor.whiteColor()
        headerView.addSubview(headlineLabel)
        
        return headerView
    }
    
    // set the header height
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
            }) { (Bool) -> Void in
                self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "patrickIsAwesome", userInfo: nil, repeats: true)
                self.timer.fire()
            }
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            timer.invalidate()
        }
        
    }
    
    func patrickIsAwesome() {
        tableViewScrollToNext(true)
    }
    
    func tableViewScrollToNext(animated: Bool) {
        
        print("scrolling to next")
        
//        let delay = 4.0 * Double(NSEC_PER_SEC)
//        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
//        
//
//        
//        dispatch_after(time, dispatch_get_main_queue(), {
//            
//            
//        })
        
        let indexPath = NSIndexPath(forRow: self.currentHeadlineRow+1, inSection: 0)
        
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: animated)
        })
    }


}

