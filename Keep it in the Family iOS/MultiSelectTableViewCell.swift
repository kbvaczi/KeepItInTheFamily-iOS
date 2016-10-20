//
//  MultiSelectTableViewCell.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/14/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

class MultiSelectTableViewCell: UITableViewCell {

    var attributeToEdit: String?
    var optionsAvailable: [[String:Any]]?
    
    func configure(attributeName: String, currentlySelected: String?, optionsAvailable: [[String:Any]]) {
        self.textLabel?.text = currentlySelected ?? "Please Select..."
        self.attributeToEdit = attributeName
        self.optionsAvailable = optionsAvailable
    }

}
