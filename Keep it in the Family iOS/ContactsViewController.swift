//
//  MasterViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/2/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit
import CoreData

class ContactsViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBAction func unwindToContacts(segue: UIStoryboardSegue) {
        
    }
    
    let connection = KIITFConnection()
    var contacts: [KIITFContact]? = nil {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ContactsViewController.addContact))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard connection.isUserLoggedIn() else {
            showLoginScreen()
            return
        }
        
        connection.getContacts() { (contacts: [KIITFContact]?, isSuccessful: Bool) -> Void in
            guard isSuccessful == true else {
                self.showLoginScreen()
                return
            }
            self.contacts = contacts
            self.tableView.reloadData()
        }
    }
    
    func addContact() {
        performSegue(withIdentifier: "newContactSegue", sender: nil)
    }
    
    func showLoginScreen() {
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contact = contacts?[indexPath.row]
                let distinationController = segue.destination as! ShowContactViewController
                distinationController.contact = contact
                distinationController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                distinationController.navigationItem.leftBarButtonItem?.title = "Contacts"
                distinationController.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let unwrappedContacts = contacts else {
            return 0
        }
        return unwrappedContacts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        if let unwrappedContacts = contacts {
            let contact = unwrappedContacts[indexPath.row]
            configureCell(cell: cell, contact: contact)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showContactSegue", sender: nil)
    }
   
    func configureCell(cell: UITableViewCell, contact: KIITFContact) {
        cell.textLabel?.text = contact.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        let nextCommunicationDateString = dateFormatter.string(from: contact.nextCommunicationDate as Date)
        cell.detailTextLabel?.text = "next check-in: " + nextCommunicationDateString + " (" + contact.communicationFrequency.rawValue + ")"
    }
    
}

