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
        let errorColor =  UIColor(red: 255, green: 0, blue: 0, alpha: 0.5)
        
        
        form = Section("")
            <<< TextRow("Name"){ row in
                row.value = contact?.name
                row.title = ""
                row.placeholder = "Contact Name"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                }
                .onChange { [weak self] row in
                    self?.contact?.name = row.value ?? ""
                }.onRowValidationChanged { cell, row in
                    let rowIndex = row.indexPath!.row
                    while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
                        row.section?.remove(at: rowIndex + 1)
                    }
                    if !row.isValid {
                        for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
                            let labelRow = LabelRow() {
                                $0.title = validationMsg
                                $0.cell.height = { 30 }
                                $0.cell.backgroundColor = errorColor
                            }
                            row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
                        }
                    }
            }
            +++ Section("Communication Details")
            <<< AlertRow<CommunicationFrequency>("Communication Frequency") { row in
                row.title = "Communication Frequency"
                row.selectorTitle = "How often to keep in touch?"
                row.options = CommunicationFrequency.allValues
                row.value = contact?.communicationFrequency ?? CommunicationFrequency.defaultValue
                }.onChange { [weak self] row in
                    guard let value = row.value else {
                        return
                    }
                    self?.contact?.communicationFrequency = value
                    let nextCommunicationRow = self?.form.rowBy(tag: "Next Check-in")
                    nextCommunicationRow?.baseValue = self?.contact?.nextCommunicationDatePredicted
                    nextCommunicationRow?.updateCell()
            }
            <<< DateInlineRow("Last Check-in"){ row in
                row.title = "Last Check-in"
                row.value = contact?.lastCommunicationDate ?? (NSDate() as Date)
                }.onChange { [weak self] row in
                    guard let value = row.value else {
                        return
                    }
                    self?.contact?.lastCommunicationDate = value
                    let nextCommunicationRow = self?.form.rowBy(tag: "Next Check-in")
                    nextCommunicationRow?.baseValue = self?.contact?.nextCommunicationDatePredicted
                    nextCommunicationRow?.updateCell()
            }
            <<< DateInlineRow("Next Check-in"){ row in
                row.title = "Next Check-in"
                row.value = contact?.nextCommunicationDate ?? ((NSDate() as Date) + TimeInterval((contact?.communicationFrequency ?? CommunicationFrequency.defaultValue).inSeconds) as Date)
                }.onChange { [weak self] row in
                    guard let value = row.value else {
                        return
                    }
                    self?.contact?.nextCommunicationDate = value
            }
            +++ Section("Notes")
            <<< TextAreaRow("Notes") { row in
                row.value = contact?.notes
                row.placeholder = "Enter Notes..."
                row.textAreaHeight = .dynamic(initialTextViewHeight: 110)
                }.onChange { [weak self] row in
                    self?.contact?.notes = row.value ?? ""
        }
    }
    
    func formValidationErrors() -> [String] {
        var validationErrors: [String] = []
        for row in form.allRows {
            if !row.isValid {
                for error in row.validationErrors {
                    validationErrors.append(error.msg)
                }
            }
        }
        return validationErrors
    }
    
    func formIsValid() -> Bool {
        var formIsValid = true
        for row in form.allRows {
            guard row.isValid else {
                formIsValid = false
                break
            }
        }
        return formIsValid
    }
    
    func configureView(contact: KIITFContact?, sourceController: UIViewController) {
        self.contact = contact
        self.sourceController = sourceController
    }

}
