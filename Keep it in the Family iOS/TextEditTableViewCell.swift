//
//  TextEditTableViewCell.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/10/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

class TextEditTableViewCell: UITableViewCell, UITextFieldDelegate, FormUpdateFieldProtocol {

    @IBOutlet weak var textField: UITextField!
    @IBAction func textFieldEdited(_ sender: AnyObject) {
        updateSource()
    }
    
    var sourceController: UIViewController?
    var attributeToEdit: String?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func configure(attributeName: String, text: String?, placeholder: String?, sourceController: UIViewController) {
        textField.text = text
        textField.placeholder = placeholder
        textField.accessibilityValue = text
        textField.accessibilityLabel = placeholder
        textField.delegate = self
        
        self.sourceController = sourceController
        self.attributeToEdit = attributeName
    }
    
    public func updateSource() {
        guard let attributeEdited = attributeToEdit else {
            return
        }
        (sourceController as? FormUpdateSourceProtocol)?.updateAttribute(attributeEdited, value: textField?.text)
    }

}
