//
//  DatePickerTableViewCell.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/10/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

class DatePickerTableViewCell: UITableViewCell, FormUpdateFieldProtocol {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func dateChanged(_ sender: AnyObject) {
        print("date changed")
        updateSource()
    }
    
    var sourceController: UIViewController?
    var attributeToEdit: String?
    
    public func configure(attributeName: String, date: Date, sourceController: UIViewController) {
        self.datePicker.date = date
        
        self.sourceController = sourceController
        self.attributeToEdit = attributeName
    }
    
    public func updateSource() {
        guard let attributeEdited = attributeToEdit else {
            return
        }
        print("date picker date" + String(describing: datePicker.date))
        (sourceController as? FormUpdateSourceProtocol)?.updateAttribute(attributeEdited, value: datePicker.date)
    }

}
