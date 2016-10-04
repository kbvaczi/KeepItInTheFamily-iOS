//
//  KITTF.swift
//  Keep it in The Family iOS
//
//  Created by KENNETH VACZI on 9/16/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class KIITFConnection {
    
    static let loginFlagKey = "KIITFLoginFlag"
    
    let rootURLString: String
    
    init(_ rootURL: String? = nil) {
        rootURLString = (rootURL == nil ? "https://www.keepitinthe.family" : rootURL!)
    }
    
    func performWithCSRFToken(_ urlString: String?, perform: @escaping (_ csrfToken: String) -> Void) {
        
        let csrfURLString = (urlString == nil ? rootURLString + "/accounts/login/" : urlString!)
        
        Alamofire.request(csrfURLString)
            .validate()
            .responseData { response in
                guard response.result.isSuccess else {
                    print("error during csrf request")
                    return
                }
                if
                    let headerFields = response.response?.allHeaderFields as? [String: String],
                    let URL = response.request?.url
                {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                    for cookie in cookies {
                        guard cookie.name == "csrftoken" else {
                            return
                        }
                        let csrfToken = cookie.value
                        perform(csrfToken)
                    }
                }
                
                print("request : \(response.request)")
                print("request.response : \(response.response)")
                print("request.result : \(response.result)")
                
        }
    }
    
    func loginRequest(email: String, password: String, callback: @escaping (_ loginSuccess: Bool) -> Void) {
        
        let loginURLString = rootURLString + "/accounts/login/"
        
        performWithCSRFToken(loginURLString){ (csrfToken: String) -> Void in
            
            let myParameters: [String: Any] = [
                "login": email,
                "password": password,
                "remember": "on",
                "csrfmiddlewaretoken": csrfToken
            ]
            
            Alamofire.request(loginURLString, method: .post, parameters: myParameters, encoding: URLEncoding.default, headers: ["referer": loginURLString])
                .validate()
                .responseData { response in
                    guard response.result.isSuccess else {
                        print("error posting login information")
                        callback(false)
                        return
                    }
                    
                    print("request : \(response.request)")
                    print("request.response : \(response.response)")
                    print("request.result : \(response.result)")
                    
                    self.setLoginFlag()
                    callback(true)
                    
                    /*if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                     print("Data: \(utf8Text)")
                     }*/
            }
        
        }
    }
    
    func setLoginFlag() {
        UserDefaults.standard.set(true, forKey: KIITFConnection.loginFlagKey)
    }
    
    func clearLoginFlag() {
        UserDefaults.standard.set(false, forKey: KIITFConnection.loginFlagKey)
    }
    
    func isUserLoggedIn() -> Bool {
        guard let loginFlag = UserDefaults.standard.value(forKey: KIITFConnection.loginFlagKey) as? Bool else {
            return false
        }
        return loginFlag
    }
    
    func retrieveJSON(_ urlString: String, callback: @escaping (_ processedResponseJSON: JSON?, _ isSuccessful: Bool) -> Void) {
        print("executing retrieveJSON, URL: \(urlString)")
        
        Alamofire.request(urlString)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess, let rawJSON = response.result.value as? NSDictionary else {
                    print("error retrieving JSON from \(urlString)")
                    //print("JSON Retrieved: \(response.result.value)")
                    callback(nil, false)
                    return
                }
                let processedJSON = JSON(rawJSON)
                print("JSON Retrieved: \(processedJSON)")
                callback(processedJSON, true)
        }
    }
    
    func getContacts(callback: @escaping (_ contactList: [KIITFContact]?, _ isSuccessful: Bool) -> Void) {
        print("Executing getContactJSON()")
        
        let contactsURLString = rootURLString + "/contacts"
        
        retrieveJSON(contactsURLString){ (processedResponseJSON: JSON?, isSuccessful: Bool) -> Void in
            guard let contactsJSON = processedResponseJSON?["results"], isSuccessful == true  else {
                self.clearLoginFlag()
                callback(nil, false)
                return
            }
            var contactsList = [KIITFContact]()
            
            for (_ ,contactJSON):(String, JSON) in contactsJSON {
                guard   let contactName = contactJSON["name"].string,
                        let contactID = contactJSON["id"].string,
                        let contactNotes = contactJSON["notes"].string,
                        let contactCommunicationFrequencyInMinutes = contactJSON["communication_frequency"].int,
                        let contactLastCommunicationDateAsString = contactJSON["last_communication"].string
                else {
                    print("error getting contact data from JSON")
                    continue
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-mm-dd"
                let contactLastCommunicationDate = dateFormatter.date(from: contactLastCommunicationDateAsString)
                
                let contactCommunicationFrequency = KIITFContact.calculateCommunicationFrequency(contactCommunicationFrequencyInMinutes)
                
                let contact = KIITFContact(contactName, id: contactID, notes: contactNotes, communicationFrequency: contactCommunicationFrequency, lastCommunicationDate: contactLastCommunicationDate)
                
                contactsList.append(contact)
            }
            
            for contact in contactsList {
                print(contact.name)
            }
            
            callback(contactsList, true)
        }
        
    }

}
