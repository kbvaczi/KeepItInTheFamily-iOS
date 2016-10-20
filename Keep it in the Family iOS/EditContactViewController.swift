//
//  ContactEditViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/10/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

protocol FormUpdateSourceProtocol {
    
    func updateAttribute(_ attributeName: String, value: Any?)
    
}

protocol FormUpdateFieldProtocol {
    
    func updateSource()
    
}

class EditContactViewController: UITableViewController, UIGestureRecognizerDelegate, FormUpdateSourceProtocol {

    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: AnyObject) {
        
        self.dismissKeyboard()
        updateAttributes()
        
        guard let contact = self.contact else {
            return
        }
        
        connection.updateContact(contact: contact) { (requestSuccess: Bool) -> Void in
            if requestSuccess {
                print("successfully updated contact")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error updating contact")
            }
        }
    }
    
    let connection = KIITFConnection()
    let sections = KIITFContactSectionInfo()
    
    var contact: KIITFContact? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditContactViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false;
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.names.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections.names[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        if contact != nil {
            switch indexPath.section {
            case sections.sectionNumberForName(name: "Name"):
                cell = tableView.dequeueReusableCell(withIdentifier: "TextEditCell", for: indexPath)
                (cell as! TextEditTableViewCell).configure(attributeName: "name", text: contact?.name, placeholder: "Enter Name", sourceController: self)
            case sections.sectionNumberForName(name: "Communication Frequency"):
                cell = tableView.dequeueReusableCell(withIdentifier: "MultiSelectCell", for: indexPath)
                (cell as! MultiSelectTableViewCell).configure(attributeName: "communicationFrequency", currentlySelected: contact?.communicationFrequency.rawValue.capitalized, optionsAvailable: CommunicationFrequency.optionsForSelect)
            case sections.sectionNumberForName(name: "Last Contact"):
                cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell", for: indexPath)
                (cell as! DatePickerTableViewCell).configure(attributeName: "lastCommunicationDate", date: (contact!.lastCommunicationDate), sourceController: self)
            case sections.sectionNumberForName(name: "Notes"):
                cell = tableView.dequeueReusableCell(withIdentifier: "TextViewEditCell", for: indexPath)
                (cell as! TextViewEditTableViewCell).configure(attributeName: "notes", text: contact?.notes, sourceController: self)
            default:
                break
            }
        }
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedCell = tableView.cellForRow(at: indexPath) as? MultiSelectTableViewCell {
            performSegue(withIdentifier: "editAttributeSegue", sender: selectedCell)
        }
    }
    
    func configureView() {
        if self.contact != nil {
            self.tableView.reloadData()
        }
    }
    
    func updateAttribute(_ attributeName: String, value: Any?) {
        print("running updateAttribute()")
        print(attributeName)
        print(value as? String)
        
        if attributeName == "name", let valueToSet = value as? String {
            contact?.name = valueToSet
        }
        if attributeName == "notes", let valueToSet = value as? String {
            contact?.notes = valueToSet
        }
        if attributeName == "communicationFrequency", let valueToSet = value as? CommunicationFrequency {
            contact?.communicationFrequency = valueToSet
        }
        if attributeName == "lastCommunicationDate", let valueToSet = value as? Date {
            print("date" + String(describing: value))
            contact?.lastCommunicationDate = valueToSet
            print(String(describing:contact?.lastCommunicationDate))
        }
    }
    
    func updateAttributes() {
        for section in (0 ..< self.tableView.numberOfSections) {
            for row in (0 ..< self.tableView.numberOfRows(inSection: section)) {
                print("checking for updating source from row " + String(row) + " section " + String(section))
                let indexPath = IndexPath(row: row, section: section)
                if let cell = (tableView.cellForRow(at: indexPath) as? FormUpdateFieldProtocol) {
                    print("updating source from row " + String(row) + " section " + String(section))
                    cell.updateSource()
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editAttributeSegue" {
            guard   let destinationController = segue.destination as? EditAttributeTableViewController,
                    let multiSelectOptions = (sender as? MultiSelectTableViewCell)?.optionsAvailable,
                    let attributeToEdit = (sender as? MultiSelectTableViewCell)?.attributeToEdit else {
                return
            }
            destinationController.attributeToEdit = attributeToEdit
            destinationController.optionsAvailable = multiSelectOptions
            destinationController.sourceViewController = self
        }
    }

}

