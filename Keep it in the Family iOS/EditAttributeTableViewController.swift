//
//  EditAttributeTableViewController.swift
//  Keep it in the Family iOS
//
//  Created by KENNETH VACZI on 10/14/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import UIKit

class EditAttributeTableViewController: UITableViewController {
    
    var sourceViewController: UIViewController?
    var attributeToEdit: String?
    var optionsAvailable: [[String:Any]]? {
        didSet {
            self.configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureView() {
        if self.optionsAvailable != nil {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsAvailable?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = optionsAvailable?[indexPath.row]["label"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard   let cellSelected = tableView.cellForRow(at: indexPath),
                let selectedOptionText = cellSelected.textLabel?.text,
                let optionsAvailable = self.optionsAvailable,
                let attributeToEdit = self.attributeToEdit else {
            return
        }
        print("edit attribute controller ", "selected cell")
        if let sourceControllerToUpdate = self.sourceViewController as? EditContactViewController {
            print("edit attribute controller ", "identified parent as contact view controller")
            
            var selectedOptionValue: Any?
            for option in optionsAvailable {
                if selectedOptionText == option["label"] as? String {
                    selectedOptionValue = option["value"]
                }
            }
            
            sourceControllerToUpdate.updateAttribute(attributeToEdit, value: selectedOptionValue)
                
            print("edit attribute controller updating parent contact")
            
        }
        self.dismiss(animated: true, completion: nil)
    }

}
