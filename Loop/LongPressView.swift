//
//  LongPressView.swift
//  Loop
//
//  Created by Patrick Weiss on 11/17/15.
//  Copyright © 2015 Patrick Weiss. All rights reserved.
//

import UIKit

class LongPressView: UIView {
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return true
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
