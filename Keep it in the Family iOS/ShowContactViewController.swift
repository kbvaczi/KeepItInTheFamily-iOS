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
    
    @IBAction func editContact(_ sender: AnyObject) {
        performSegue(withIdentifier: "editContactFromShowSegue", sender: nil)
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let contact: KIITFContact = self.detailItem {
            self.tableView.reloadData()
            self.navigationItem.title = contact.name
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
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
        if let contact: KIITFContact = self.detailItem {
            switch indexPath.section {
            case sections.sectionNumberForName(name: "Name"):
                cell.textLabel?.text = contact.name
            case sections.sectionNumberForName(name: "Communication Frequency"):
                cell.textLabel?.text = contact.communicationFrequency.rawValue.capitalized
            case sections.sectionNumberForName(name: "Last Contact"):
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-mm-dd"
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: KIITFContact? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContactFromShowSegue" {
            if let contact: KIITFContact = self.detailItem {
                let destination = segue.destination as! UINavigationController
                let controller = destination.childViewControllers.first as! EditContactViewController
                controller.contact = contact
                //controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                //controller.navigationItem.leftItemsSupplementBackButton = true
                let backItem = UIBarButtonItem()
                backItem.title = "Cancel"
                navigationItem.backBarButtonItem = backItem
            }
        }
    }
}

