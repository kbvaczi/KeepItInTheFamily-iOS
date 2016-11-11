//
//  RootTabBarController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 11/11/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit
import FontAwesome_swift

class RootTabBarController: UITabBarController {
    
    private enum TabTitles: String, CustomStringConvertible {
        case Contacts
        case Account
        
        var description: String {
            return self.rawValue
        }
    }
    
    private var tabIcons = [
        TabTitles.Contacts: FontAwesome.group,
        TabTitles.Account: FontAwesome.infoCircle,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarItems = tabBar.items {
            for item in tabBarItems {
                if let title = item.title,
                    let tab = TabTitles(rawValue: title),
                    let glyph = tabIcons[tab] {
                    item.image = UIImage.fontAwesomeIcon(name: glyph, textColor: UIColor.blue, size: CGSize(width: 30, height: 30))
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
