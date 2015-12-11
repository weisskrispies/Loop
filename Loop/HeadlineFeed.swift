//
//  HeadlineFeed.swift
//  Loop
//
//  Created by Patrick Weiss on 12/3/15.
//  Copyright © 2015 Patrick Weiss. All rights reserved.
//

import UIKit

class HeadlineFeed: UIViewController {

    @IBOutlet weak var headlineCategory: UILabel!
    @IBOutlet weak var headlineText: UILabel!
    @IBOutlet weak var headlineBackground: UIView!
    @IBOutlet weak var welcomeHitHint: UIImageView!
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var welcomeMessageLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!

    
    var newsHeadlines = [PFObject]()
    var currentHeadline = 0
    
    var readingTimePerArticle = 4.0
    
    var welcomeScreenShowing = true

    var timer: NSTimer!
    var progress: Float!
    
    var categories = ["NEED TO KNOW", "LOCAL", "TECH + DESIGN", "HOSPITALITY", "FROM YOUR FRIENDS"]
    var dayOfTheWeek = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    
    var darkPurpleColor = UIColor(red: 109/255, green: 67/255, blue: 120/255, alpha: 1.0)
    var lightPurpleColor = UIColor(red: 132/255, green: 96/255, blue: 140/255, alpha: 1.0)
    var lightTurquoise = UIColor(red: 53/255, green: 166/255, blue: 165/255, alpha: 1.0)
    var darkTurquoise = UIColor(red: 36/255, green: 110/255, blue: 139/255, alpha: 1.0)
    var darkBlue = UIColor(red: 60/255, green: 62/255, blue: 112/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // defines the date for today
        let today = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        
        var headlines = PFObject(className: "Headlines")
        
        let query = PFQuery(className: "Headlines")
        
        if let weekday = getDayOfWeek("2014-08-27") {
            welcomeMessageLabel.text = "Your top news for \(dayOfTheWeek[weekday])"
        } else {
            print("bad input")
        }
        
        // scans for only stories in Parse with today's date
        query.whereKey("headline_date", greaterThan: today)

        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects
                where error == nil {
//                print("Successfully retrieved: \(objects)")

                for headline in objects{
                    self.newsHeadlines.append(headline)
                }
                self.loadNextStory()
                
            } else {
                print("Error: \(error)")
            }
        }
        
        UIView.animateWithDuration(1.0, delay: 0.0, options: [UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.Repeat], animations: { () -> Void in
            self.welcomeHitHint.transform = CGAffineTransformMakeScale(1.3, 1.3)
            }) { (Bool) -> Void in
        }
        
        let headlineCount = newsHeadlines.count
        print("Total Headlines Today: \(headlineCount)")
        
    }
    
//    @IBAction func onHeadlineTap(sender: AnyObject) {
//        
//        currentHeadline++
//        if currentHeadline < newsHeadlines.count {
//
//            UIView.animateWithDuration(0.3, animations: { () -> Void in
//                self.headlineText.alpha = 0
//                }, completion: { (Bool) -> Void in
//                    self.loadNextStory()
//            })
//            
//
//            
//        } else {
//            
//        }
//        
//
//    }
    
    @IBAction func onLongPress(sender: AnyObject) {
        
        print("did recognize long press")
        
//        self.progressView.setProgress(0.0, animated: false)
//        print("initial progress reset")
//        
//        UIView.animateWithDuration(self.readingTimePerArticle, animations: { () -> Void in
//            self.progressView.setProgress(1.0, animated: true)
//            print("go progress go")
//        })
        
        if sender.state == UIGestureRecognizerState.Began {
        
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.welcomeView.alpha = 0
                
                UIView.animateWithDuration(self.readingTimePerArticle, animations: { () -> Void in
                    self.progressView.setProgress(1.0, animated: true)
                    print("go progress go")
                })
                
            })
            
            // turns off welcome screen delay after first dismissed
            if self.welcomeScreenShowing == true {
                self.delay(self.readingTimePerArticle-1, closure: { () -> () in
                    
                    self.welcomeScreenShowing = false
                    print("welcome delay off")
                    
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(self.readingTimePerArticle, target: self, selector: "switchToNextStory", userInfo: nil, repeats: true)
                    
                    self.timer.fire()
                    
                })
            } else {
                
                self.timer = NSTimer.scheduledTimerWithTimeInterval(self.readingTimePerArticle, target: self, selector: "switchToNextStory", userInfo: nil, repeats: false)
                
                self.timer.fire()
            }
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            timer.invalidate()
        }
        
    }
    
    func switchToNextStory() {
        
        self.progressView.setProgress(0.0, animated: false)
        print("initial progress reset")
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.headlineText.alpha = 0
            }) { (Bool) -> Void in
                
                UIView.animateWithDuration(self.readingTimePerArticle, animations: { () -> Void in
                    self.progressView.setProgress(1.0, animated: true)
                    print("go progress go")
                })
                
                self.loadNextStory()
                //                print("story #\(self.currentHeadline) loaded")
                
        }
        
    }
    
    func loadNextStory() {
        
        if currentHeadline < newsHeadlines.count {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                let headline = self.newsHeadlines[self.currentHeadline]
                
                if let categoryString = headline["Category"] as? String {
                    self.headlineCategory.text = categoryString.uppercaseString
                
                    switch categoryString {
                    case "Need to know": self.headlineBackground.backgroundColor = self.darkPurpleColor
                    case "Local": self.headlineBackground.backgroundColor = self.lightPurpleColor
                    case "Tech + Design": self.headlineBackground.backgroundColor = self.lightTurquoise
                    case "Entertainment": self.headlineBackground.backgroundColor = self.darkTurquoise
                    case "Random Facts": self.headlineBackground.backgroundColor = self.darkBlue
                    default: self.headlineBackground.backgroundColor = self.darkPurpleColor
                        
                    }
                }
                
                if let headlineString = headline["Headline"] as? String {
                    self.headlineText.text = headlineString
                }
                self.headlineCategory.alpha = 1
                self.headlineText.alpha = 1
                
            })
        } else {
            self.performSegueWithIdentifier("HeadlinesCompleteSegue", sender: nil)
        }

        currentHeadline++
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func getDayOfWeek(today:String)->Int? {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
