//
//  ViewController.swift
//  Keep it in The Family iOS
//
//  Created by KENNETH VACZI on 9/11/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    let connection = KIITFConnection()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func login(_ sender: UIButton) {
        guard   let userEmail = emailTextField.text,
                let userPassword = passwordTextField.text else {
            return
        }
        
        connection.loginRequest(email: userEmail, password: userPassword) { (loginSuccess: Bool) -> Void in
            if loginSuccess {
                print("login successful")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("login failure")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20 , execute: connection.getContactsJSON)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

