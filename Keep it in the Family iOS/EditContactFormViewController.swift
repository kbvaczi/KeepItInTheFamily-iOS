//
//  EditContactFormViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/20/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

class EditContactFormViewController: ContactsFormViewController {
    

    @IBAction func cancelEditing(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveContact(_ sender: AnyObject) {
        guard   let contactUnwrapped = contact,
                formIsValid() else {
            return
        }
        
        connection.updateContact(contact: contactUnwrapped) { (requestSuccess: Bool) -> Void in
            if requestSuccess {
                print("successfully updated contact")
                (self.sourceController as? ShowContactViewController)?.contact = contactUnwrapped
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error updating contact")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
