//
//  ViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/9/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var accountLabel: UILabel!
    @IBAction func logout(_ sender: UIButton) {
        connection.logoutRequest() { (logoutSuccess: Bool) -> Void in
            if logoutSuccess {
                self.accountLabel.text = ""
            }
        }
    }
    
    let connection = KIITFConnection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        accountLabel.text = connection.userAccountEmail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
