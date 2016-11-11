//
//  MasterViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/2/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit
import CoreData
import FontAwesome_swift
import MGSwipeTableCell

class ContactsViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBAction func unwindToContacts(segue: UIStoryboardSegue) {}
    
    let connection = KIITFConnection()
    var contacts: [KIITFContact]? = nil {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ContactsViewController.presentNewContactForm))
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard connection.isUserLoggedIn() else {
            showLoginScreen()
            return
        }
        configureView()
    }
    
    func checkInContact(_ contact: KIITFContact) {
        var mutableContact = contact
        let today = Date()
        mutableContact.lastCommunicationDate = today
        mutableContact.nextCommunicationDate = mutableContact.nextCommunicationDatePredicted
        self.connection.updateContact(contact: mutableContact) { (isSuccess) -> Void in
            self.configureView()
            print("update successful")
        }
    }
    
    func delayContact(_ contact: KIITFContact) {
        var mutableContact = contact
        let today = Date()
        let oneWeek = TimeInterval(CommunicationFrequency.weekly.inSeconds)
        if mutableContact.nextCommunicationDate <= today {
            mutableContact.nextCommunicationDate = today + oneWeek
        } else {
            mutableContact.nextCommunicationDate = mutableContact.nextCommunicationDate + oneWeek
        }
        self.connection.updateContact(contact: mutableContact) { (isSuccess) -> Void in
            self.configureView()
            print("update successful")
        }
    }
    
    func presentNewContactForm() {
        performSegue(withIdentifier: "newContactSegue", sender: nil)
    }
    
    func addNewContact(contact: KIITFContact) {
        self.contacts?.append(contact)
    }
    
    func showLoginScreen() {
        performSegue(withIdentifier: "loginSegue", sender: nil)
    }
    
    func configureView() {
        connection.getContacts() { (contacts: [KIITFContact]?, isSuccessful: Bool) -> Void in
            guard isSuccessful == true else {
                self.showLoginScreen()
                return
            }
            self.contacts = contacts
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
        
        let reuseIdentifier = "ContactCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! MGSwipeTableCell!
        if cell == nil
        {
            cell = MGSwipeTableCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        if let unwrappedContacts = contacts {
            let contact = unwrappedContacts[indexPath.row]
            configureCell(cell: cell!, contact: contact)
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        
        if let swipeCell = cell as? MGSwipeTableCell {
            let iconForCheckedIn = UIImage.fontAwesomeIcon(name: FontAwesome.check, textColor: UIColor.white, size: CGSize(width: 40, height: 40), backgroundColor: UIColor.clear)
            let iconForDelay = UIImage.fontAwesomeIcon(name: FontAwesome.clockO, textColor: UIColor.white, size: CGSize(width: 40, height: 40), backgroundColor: UIColor.clear)
            let checkedInButton = MGSwipeButton(title: "", icon: iconForCheckedIn, backgroundColor: UIColor.blue, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                print("contact button tapped")
                self.checkInContact(contact)
                return true
            })
            let delayButton = MGSwipeButton(title: "", icon: iconForDelay, backgroundColor: UIColor.lightGray, callback: {
                (sender: MGSwipeTableCell!) -> Bool in
                print("delay button tapped")
                self.delayContact(contact)
                return true
            })

            swipeCell.rightButtons = [checkedInButton, delayButton]
            swipeCell.rightSwipeSettings.transition = MGSwipeTransition.drag
            
        }
    
    }    
    
    // MARK: - Navigation
    
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
        } else if segue.identifier == "newContactSegue" {
            guard   let destinationNVC = segue.destination as? UINavigationController,
                    let newContactVC = destinationNVC.childViewControllers.first as? NewContactFormViewController else {
                return
            }
            newContactVC.contactsViewController = self
        }
    }
    
}
