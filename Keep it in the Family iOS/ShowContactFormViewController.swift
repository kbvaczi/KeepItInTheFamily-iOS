//
//  ShowContactFormViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 11/1/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

class ShowContactFormViewController: ContactsFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        disableInputs()
        // Do any additional setup after loading the view.
    }
    
    func editContact() {
        performSegue(withIdentifier: "editContactFormSegue", sender: nil)
    }
    
    func configureNavigationBar() {
        self.navigationItem.title = contact?.name ?? ""
        if contact != nil {
            let editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ShowContactViewController.editContact))
            self.navigationItem.rightBarButtonItem = editBarButton
        }
    }
    
    func disableInputs() {
        print("disabling inputs")
        for row in form.allRows {
            print(row.tag)
            print(row.disabled)
            row.disabled = Eureka.Condition.function([""], { (form) -> Bool in
                return true
            })
            print(row.disabled)
            row.updateCell()
        }
    }
    
    override func configureView(contact: KIITFContact?, sourceController: UIViewController) {
        super.configureView(contact: contact, sourceController: sourceController)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
