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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let contact: KIITFContact = self.contact {
            switch indexPath.section {
            case sections.sectionNumberForName(name: "Name"):
                cell.textLabel?.text = contact.name
            case sections.sectionNumberForName(name: "Communication Frequency"):
                cell.textLabel?.text = contact.communicationFrequency.rawValue.capitalized
            case sections.sectionNumberForName(name: "Last Contact"):
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                let lastCommunicationDateString = dateFormatter.string(from: contact.lastCommunicationDate)
                cell.textLabel?.text = lastCommunicationDateString
            case sections.sectionNumberForName(name: "Notes"):
                cell.textLabel?.text = contact.notes
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

