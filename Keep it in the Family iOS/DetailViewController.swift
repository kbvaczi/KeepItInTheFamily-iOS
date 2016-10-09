//
//  DetailViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/2/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    let sections = SectionInformation()
    
    func configureView() {
        // Update the user interface for the detail item.
        self.tableView.reloadData()
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
                let dateformatter = DateFormatter()
                dateformatter.dateStyle = DateFormatter.Style.long
                let lastCommunicationDateString = dateformatter.string(from: contact.lastCommunicationDate as Date)
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
        // Do any additional setup after loading the view, typically from a nib.
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
}

class SectionInformation {
    let names = ["Name", "Communication Frequency", "Last Contact", "Notes"]
    
    func sectionNumberForName(name: String) -> Int {
        return names.index(of: name) ?? 99
    }
}

