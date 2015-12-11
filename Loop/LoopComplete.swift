//
//  LoopComplete.swift
//  Loop
//
//  Created by Patrick Weiss on 12/3/15.
//  Copyright © 2015 Patrick Weiss. All rights reserved.
//

import UIKit

class LoopComplete: UIViewController {

    @IBOutlet weak var loopCompletedImages: UIImageView!
    @IBOutlet weak var checkMark: UIImageView!
    @IBOutlet weak var headerText: UILabel!
    @IBOutlet weak var completeText: UILabel!
    @IBOutlet weak var completeCircle: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkMark.alpha = 0
        headerText.alpha = 0
        completeText.alpha = 0
        loopCompletedImages.alpha = 0
        completeCircle.alpha = 0

        self.loopCompletedImages.animationImages =   [UIImage(named:"LoopComplete-1.png")!,
            UIImage(named:"LoopComplete-2.png")!,
            UIImage(named:"LoopComplete-3.png")!,
            UIImage(named:"LoopComplete-4.png")!]
        

        
        
        
        delay(1.0) { () -> () in
            UIView.animateWithDuration(0.9, animations: { () -> Void in
                self.headerText.alpha = 1
                self.completeText.alpha = 1
                }, completion: { (Bool) -> Void in
                    self.loopCompletedImages.alpha = 1
                    self.loopCompletedImages.animationDuration = 3.0
                    self.loopCompletedImages.animationRepeatCount = 1
                    self.loopCompletedImages.startAnimating()
            })
            
        }

        
        delay(4, closure: { () -> () in
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.checkMark.alpha = 1
                self.completeCircle.alpha = 1
            })
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
