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
    
    var headlines: [PFObject]! = []

    var timer: NSTimer!
    
    var currentHeadlineRow: Int = 0
    
//    var headlines = ["Square files for much-anticipated IPO", "Hurricane Joaquin headed for eastern US this weekend", "Steve Ballmer now owns 4% of Twitter", "San Francisco passes law to eliminate sales tax by 2020", "California records warmest October in past 200 years", "Marina man wanted for arson arrested", "Tinder parent company files for IPO in November", "Elon Musk shows off first working Hyperloop prototype", "Couch Surfing announces partnership with Hyatt & Marriott Hotels", "Kate Montgomery has a new job at Lendable"]
    
    var categories = ["NEED TO KNOW", "NEED TO KNOW", "NEED TO KNOW", "LOCAL", "LOCAL", "LOCAL", "TECH + DESIGN", "TECH + DESIGN", "HOSPITALITY", "FROM YOUR FRIENDS"]
    
    var lightPurpleColor = UIColor(red: 132/255, green: 96/255, blue: 140/255, alpha: 1.0)
    var darkPurpleColor = UIColor(red: 109/255, green: 67/255, blue: 120/255, alpha: 1.0)
    
    // Instantiate long press gesture
    let longPress: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer()
        return recognizer
        }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // querries the parse database for content and populates the table
        let query = PFQuery(className: "Headlines")
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in

            self.headlines = results
            self.tableView.reloadData()
            
        }
        
//        let numberOfSections = tableView.numberOfSections
//        let numberOfRowsInSection = tableView.numberOfRowsInSection(numberOfSections-1)
        
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headlines.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        print("Row: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HeadlineCell") as! HeadlineCell
        
        let headline = headlines[indexPath.row]
        cell.headlineLabel.text = headline["Headline"] as? String
        
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
                self.hitHintCircleImage.alpha = 0
                self.hitHintDotImage.alpha = 0
                
                }) { (Bool) -> Void in
                    
                    self.delay(2.0, closure: { () -> () in
                        
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "patrickIsAwesome", userInfo: nil, repeats: true)
                        self.timer.fire()
                        
                    })
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
        
        let indexPath = NSIndexPath(forRow: self.currentHeadlineRow+1, inSection: 0)
        
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: animated)
        })
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

