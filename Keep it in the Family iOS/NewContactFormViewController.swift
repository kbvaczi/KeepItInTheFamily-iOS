//
//  NewContactFormViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/23/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit
import Eureka

class NewContactFormViewController: ContactsFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        contact = KIITFContact()
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(NewContactFormViewController.cancel))
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        let createBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(NewContactFormViewController.createNewContact))
        self.navigationItem.rightBarButtonItem = createBarButton
    }

    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createNewContact() {
        guard   let contactUnwrapped = contact,
                formIsValid() else {
            return
        }
        
        connection.createContact(contact: contactUnwrapped) { (requestSuccess: Bool) -> Void in
            if requestSuccess {
                print("successfully created contact")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error creating contact")
            }
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
