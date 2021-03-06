//
//  HeadlineFeed.swift
//  Loop
//
//  Created by Patrick Weiss on 12/3/15.
//  Copyright © 2015 Patrick Weiss. All rights reserved.
//

import UIKit

class HeadlineFeed: UIViewController, CLTypingLabelDelegate {

    @IBOutlet weak var headlineCategory: UILabel!
    @IBOutlet weak var headlineText: CLTypingLabel!
    @IBOutlet weak var headlineBackground: UIView!
    @IBOutlet weak var hitHintLabel: UILabel!
    @IBOutlet weak var backgroundTintView: UIView!
    @IBOutlet weak var tutorialOverlay: UIView!
    @IBOutlet weak var tutorialOverlayTopView: UIView!
    @IBOutlet weak var hitHintOuterCircle: UIImageView!
    
    var newsHeadlines = [PFObject]()
    var currentHeadline = 0

    var readingTimePerArticle = 6.0
    var typeAnimationDuration = 0.05
    var totalReadingTime = 0
    
    var cyclingThroughArticles = false

    // gets the number of times that the app has been opened (from the AppDelegate)
    var defaults = NSUserDefaults.standardUserDefaults()
    var appOpenCount = NSUserDefaults.standardUserDefaults().integerForKey("launchCount")
    var showingInstructionalModal = false
    
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
        
        print("App opened: \(appOpenCount) times")
        
        var headlines = PFObject(className: "Headlines")
        
        let query = PFQuery(className: "Headlines")
        
        tutorialOverlayTopView.backgroundColor = darkBlueColor
        backgroundTintView.alpha = 0
        
        //runs logic to determine if the app has been open and the tutorial seen > x times
        showInstructionalModal()

        headlineText.delegate = self

        // defines the date for today
        let today = NSCalendar.currentCalendar().startOfDayForDate(NSDate())
        
        // scans for only stories in Parse with today's date
        query.whereKey("headline_date", greaterThan: today)

        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let objects = objects
                where error == nil {
//                print("Successfully retrieved: \(objects)")
                    print("\(objects.count) Articles")
                    
                    // identify # of headlines and time to read
                    self.totalReadingTime = Int(Double(objects.count) * self.readingTimePerArticle)

                for headline in objects{
                    self.newsHeadlines.append(headline)
                    
                }
                self.loadNextStory()
                
            } else {
                print("Error: \(error)")
            }
        }
        
    }
    
    @IBAction func onLongPress(sender: AnyObject) {
        
//        print("did recognize long press")
        
        if sender.state == UIGestureRecognizerState.Began {
            
            if showingInstructionalModal == true {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.tutorialOverlay.alpha = 0
                    
                })
            }
            
            //Brightens screen when the user is holding
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.backgroundTintView.alpha = 0
                
            })

            
            // initiates typewriter animation (from CLTypingLabel)
            self.headlineText.charInterval = self.typeAnimationDuration
            
            if !cyclingThroughArticles {
                
                headlineText.continueTyping()
                
                cyclingThroughArticles = true

            }
            
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
//            timer.invalidate()

            cyclingThroughArticles = false
            
            headlineText.pauseTyping()
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.backgroundTintView.alpha = 0.5
            })
        }
    }
    
    
    func switchToNextStory() {
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.headlineText.alpha = 0
            }) { (Bool) -> Void in
                
                self.loadNextStory()
        }
    }
    
    func loadNextStory() {
        
        if currentHeadline < newsHeadlines.count {
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                let headline = self.newsHeadlines[self.currentHeadline]
                
                if let categoryString = headline["Category"] as? String {
                    self.headlineCategory.text = categoryString.uppercaseString
                
                    switch categoryString {
                    case "Need to Know": self.headlineBackground.backgroundColor = self.darkBlueColor
                    case "Local": self.headlineBackground.backgroundColor = self.lighterBlueColor
                    case "Tech + Design": self.headlineBackground.backgroundColor = self.darkRedColor
                    case "Entertainment": self.headlineBackground.backgroundColor = self.lighterRedColor
                    case "Random Facts": self.headlineBackground.backgroundColor = self.yellowColor
                    default: self.headlineBackground.backgroundColor = self.darkBlueColor
                        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func typingLabelDidFinishTyping(label: CLTypingLabel) {
        delay(1) { () -> () in
            self.switchToNextStory()
        }
    }
    
    func showInstructionalModal() {
        
        if appOpenCount <= 2 {
            
            delay(0.75) { () -> () in
                UIView.animateWithDuration(0.5, delay: 0, options: [], animations: { () -> Void in
                    self.tutorialOverlay.alpha = 1
                    
                    }) { (Bool) -> Void in
                        
                }
                
                UIView.animateWithDuration(1.0, delay: 0.0, options: [UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.Repeat], animations: { () -> Void in
                    self.hitHintOuterCircle.transform = CGAffineTransformMakeScale(1.3, 1.3)
                    }, completion: { (Bool) -> Void in
                })
                
            }
            
            showingInstructionalModal = true
        } else {
            print("No need to show instructions, they already done seen it")
        }
        
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
