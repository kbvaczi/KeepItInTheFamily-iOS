//
//  EditContactFormViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/20/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

class EditContactFormViewController: FormViewController {
    

    @IBAction func cancelEditing(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveContact(_ sender: AnyObject) {
        guard let contactUnwrapped = contact else {
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
    
    var contact: KIITFContact?
    var sourceController: UIViewController?
    let connection = KIITFConnection()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureForm()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureForm() {
        form = Section("")
            <<< TextRow(){ row in
                row.value = contact?.name
                row.title = ""
                row.placeholder = "Contact Name"
                }
                .onChange { row in
                    guard let value = row.value else {
                        return
                    }
                    self.contact?.name = value
            }
            +++ Section("Communication Details")
            <<< AlertRow<CommunicationFrequency>() { row in
                row.title = "Communication Frequency"
                row.selectorTitle = "How often to keep in touch?"
                row.options = CommunicationFrequency.allValues
                row.value = contact?.communicationFrequency ?? .monthly
                }.onChange { row in
                    guard let value = row.value else {
                        return
                    }
                    self.contact?.communicationFrequency = value
            }
            <<< DateRow(){ row in
                row.title = "Last Check-in"
                row.value = contact?.lastCommunicationDate ?? (NSDate() as Date)
                }.onChange { row in
                    guard let value = row.value else {
                        return
                    }
                    self.contact?.lastCommunicationDate = value
            }
            +++ Section("Notes")
            <<< TextAreaRow() { row in
                row.value = contact?.notes
                row.placeholder = "Enter Notes..."
                row.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                }.onChange { row in
                    guard let value = row.value else {
                        self.contact?.notes = ""
                        return
                    }
                    self.contact?.notes = value
        }
    }
    
    func configureView(contact: KIITFContact?, sourceController: UIViewController) {
        self.contact = contact
        self.sourceController = sourceController
    }

}
