//
//  TextViewEditTableViewCell.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/14/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

class TextViewEditTableViewCell: UITableViewCell, UITextViewDelegate, FormUpdateFieldProtocol {

    @IBOutlet weak var textView: UITextView!
    
    var sourceController: UIViewController?
    var attributeToEdit: String?
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        updateSource()
    }
    
    public func configure(attributeName: String, text: String?, sourceController: UIViewController) {
        textView.text = text
        textView.accessibilityValue = text
        self.textView.delegate = self
        
        self.sourceController = sourceController
        self.attributeToEdit = attributeName
    }
    
    public func updateSource() {
        guard let attributeEdited = attributeToEdit else {
            return
        }
        (sourceController as? FormUpdateSourceProtocol)?.updateAttribute(attributeEdited, value: textView.text)
    }

}
