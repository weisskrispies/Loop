//
//  TypewritterTestViewController.swift
//  Loop
//
//  Created by Patrick Weiss on 2/29/16.
//  Copyright © 2016 Patrick Weiss. All rights reserved.
//

import UIKit

class TypewritterTestViewController: UIViewController {

    @IBOutlet weak var label: CLTypingLabel!
    
    @IBOutlet weak var myTyperLabel: CLTypingLabel!
    
//    let myText = Array("Hello World !!!".characters)
//    var myCounter = 0
//    var timerTyping:NSTimer?
    
//    func fireTimer(){
//        timerTyping = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "typeLetter", userInfo: nil, repeats: true)
//    }
//    
//    func typeLetter(){
//        if myCounter < myText.count {
//            myTyperLabel.text = myTyperLabel.text! + String(myText[myCounter])
//            timerTyping?.invalidate()
//            timerTyping = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "typeLetter", userInfo: nil, repeats: false)
//        } else {
//            timerTyping?.invalidate()
//        }
//        myCounter++
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        fireTimer()
        
        myTyperLabel.charInterval = 0.08
        myTyperLabel.text = "This is a demo of a typing label animation..."
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure
        )
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
