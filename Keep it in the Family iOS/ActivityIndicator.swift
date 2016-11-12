//
//  ActivityIndicator.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 11/12/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

class ActivityIndicator: UIActivityIndicatorView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    public func addToView (_ view: UIView) {
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.hidesWhenStopped = true
        self.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        view.addSubview(self)
    }

}
