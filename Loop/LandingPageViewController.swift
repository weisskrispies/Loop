//
//  LandingPageViewController.swift
//  Loop
//
//  Created by Patrick Weiss on 1/7/16.
//  Copyright © 2016 Patrick Weiss. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var welcomeMessageSubLabel: UILabel!
    @IBOutlet weak var tapToBeginLabel: UILabel!
    
    var newsHeadlines = [PFObject]()
    
    var readingTimePerArticle = 6.0
    var totalReadingTime = 0
    
    var storiesLoaded = false
    
    var timer: NSTimer!
    var progress: Float!
    
    var categories = ["NEED TO KNOW", "LOCAL", "TECH + DESIGN", "HOSPITALITY", "FROM YOUR FRIENDS"]
    
    var darkBlueColor = UIColor(red: 11/255, green: 29/255, blue: 41/255, alpha: 1.0)
    var lighterBlueColor = UIColor(red: 6/255, green: 43/255, blue: 69/255, alpha: 1.0)
    var darkRedColor = UIColor(red: 50/255, green: 7/255, blue: 7/255, alpha: 1.0)
    var lighterRedColor = UIColor(red: 82/255, green: 1/255, blue: 0/255, alpha: 1.0)
    var yellowColor = UIColor(red: 69/255, green: 69/255, blue: 12/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var headlines = PFObject(className: "Headlines")
        
        let query = PFQuery(className: "Headlines")
        
        // defines the date for today
        let today = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        
        // converts the date to the day of the week
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeekString = dateFormatter.stringFromDate(today)
        print(dayOfWeekString)
        
        // scans for only stories in Parse with today's date
        query.whereKey("headline_date", greaterThan: today)
        
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects
                where error == nil {

                    print("Successfully retrieved: \(objects)")
                    print("\(objects.count) Articles")
                    
                    if objects.count > 0 {
                        
                        self.welcomeMessageLabel.text = "Your top news for \(dayOfWeekString)"
                        
                        // identify # of headlines and time to read
                        self.totalReadingTime = Int(Double(objects.count) * self.readingTimePerArticle)
                        print ("total reading time: \(self.totalReadingTime)")
                        self.welcomeMessageSubLabel.text = "Everything you need to know, in \(self.totalReadingTime) seconds."
                        
                        self.tapToBeginLabel.alpha = 1
                        
                        self.storiesLoaded = true
                        
                    } else {
                        
                        self.welcomeMessageLabel.text = "Patrick officially dropped the ball."
                        
                        self.welcomeMessageSubLabel.text = "No headlines yet, please check back in a bit."
                    }
                    
            } else {
                print("Error: \(error)")
                self.welcomeMessageLabel.text = "Damn yo, you're offline!"
                self.welcomeMessageSubLabel.text = "Hop on the internets to get some news"
            }
        }
        
    }
    
    @IBAction func onTap(sender: AnyObject) {
        
        print("did recognize tap")
        
        if storiesLoaded == true {
            self.performSegueWithIdentifier("StartReadingSegue", sender: nil)
        } else {
             
        }

        
    }
    
    
   
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func unwindToLanding(segue: UIStoryboardSegue) {
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
