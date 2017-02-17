//
//  ThemeManager.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 11/13/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

struct ThemeManager {
    
    
    
    static var mainColor = UIColor(red: 0.357, green: 0.443, blue: 0.702, alpha: 1.0)
    
    static var backgroundColor = UIColor(red: 0.773, green: 0.765, blue: 0.812, alpha: 1.0) //77.3, 76.5, 81.2
    static var backgroundColorLight = UIColor(red: 0.937, green: 0.929, blue: 0.992, alpha: 1.0) //93.7, 92.9, 99.2
    static var backgroundColorDark = UIColor(red: 0.573, green: 0.561, blue: 0.627, alpha: 1.0) //57.3, 56.1, 62.7
    
    static func applyTheme() {
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = ThemeManager.mainColor
        sharedApplication.delegate?.window??.inputView?.tintColor = ThemeManager.mainColor
        
        UINavigationBar.appearance().backgroundColor = ThemeManager.backgroundColor
        
        UITableView.appearance().backgroundColor = ThemeManager.backgroundColorLight
    }

    var whatever: class("UITableView")
    
    static var itemsWithLightBackground = [UITableView]
    
    static var itemsWithMediumBackground = [UINavigationBar, UITabBar]
}

