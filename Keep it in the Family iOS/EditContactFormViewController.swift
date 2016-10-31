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
        addDeleteButtonToForm()
    }
    
    func addDeleteButtonToForm() {
        form
        +++ Section()
        <<< ButtonRow() {
            $0.title = "Delete This Contact"
            $0.baseCell.tintColor = UIColor.red
            }.onCellSelection { [weak self] cell, row in
                self?.promptForDeleteContact()
        }
    }

    func promptForDeleteContact() {
        let alert = UIAlertController(title: "Warning!", message: "Are you sure you want to delete this contact?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: deleteContact))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteContact(action: UIAlertAction) -> Void {
        guard let contactUnwrapped = contact else {
            return
        }
        
        connection.deleteContact(contact: contactUnwrapped) { (wasSuccessful) -> Void in
            if wasSuccessful {
                (self.presentingViewController as? ShowContactViewController)?.contact = nil
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Oops!", message: "We were unable to delete this contact. Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
