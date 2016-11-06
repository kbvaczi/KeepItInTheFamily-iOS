//
//  DetailViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/2/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

class ShowContactViewController: UITableViewController {
    
    let sections = KIITFContactSectionInfo()
    
    var contact: KIITFContact? {
        didSet {
            self.configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        configureView()
    }
    
    func configureView() {
        self.tableView.reloadData()
        self.navigationItem.title = contact?.name ?? ""
        if contact != nil {
            let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ShowContactViewController.editContact))
            self.navigationItem.rightBarButtonItem = editBarButton
        }
    }
    
    func editContact() {
        performSegue(withIdentifier: "editContactFormSegue", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard contact != nil else {
            return 0
        }
        return sections.names.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections.names[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.numberRowsInSection[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let contact: KIITFContact = self.contact {
            switch indexPath.section {
            case sections.sectionNumberForDescription(desc: "Name"):
                cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                cell.textLabel?.text = contact.name
                cell.detailTextLabel?.text = nil
            case sections.sectionNumberForDescription(desc: "Communication Details"):
                cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                switch indexPath.row {
                case 0:
                    cell.textLabel?.text = "Frequency"
                    cell.detailTextLabel?.text = contact.communicationFrequency.rawValue.capitalized
                case 1:
                    cell.textLabel?.text = "Last Check-in"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = DateFormatter.Style.medium
                    let lastCommunicationDateString = dateFormatter.string(from: contact.lastCommunicationDate)
                    cell.detailTextLabel?.text = lastCommunicationDateString
                default:
                    cell.textLabel?.text = "Next Check-in"
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = DateFormatter.Style.medium
                    let nextCommunicationDateString = dateFormatter.string(from: contact.nextCommunicationDate)
                    cell.detailTextLabel?.text = nextCommunicationDateString
                }
            case sections.sectionNumberForDescription(desc: "Notes"):
                cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath) as! TextViewTableViewCell
                (cell as? TextViewTableViewCell)?.textView.text = contact.notes
            default:
                break
            }
        }        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    


    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContactFormSegue" {
            guard let contactUnwrapped = self.contact else {
                return
            }
            let destinationNav = segue.destination as! UINavigationController
            let destinationController = destinationNav.childViewControllers.first as! EditContactFormViewController
            destinationController.configureView(contact: contactUnwrapped, sourceController: self)
            let backItem = UIBarButtonItem()
            backItem.title = "Cancel"
            destinationController.navigationItem.backBarButtonItem = backItem
            
        }
    }
}

class KIITFContactSectionInfo {
    let description = ["Name", "Communication Details", "Notes"]
    let names = ["", "Communication Details", "Notes"]
    let numberRowsInSection = [1,3,1]
    
    func sectionNumberForDescription(desc: String) -> Int {
        return description.index(of: desc) ?? 99
    }
}

class TextViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
}


