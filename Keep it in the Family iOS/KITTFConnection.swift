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
    static let accountKey = "KIITFAccount"
    static let serverDateFormat = "YYYY-MM-dd"
    
    let rootURLString: String
    
    init(_ rootURL: String? = nil) {
        rootURLString = (rootURL == nil ? "https://www.keepitinthe.family" : rootURL!)
    }
    
    
    // MARK - GENERAL COMMUNICATION FUNCTIONS
    
    func performWithCSRFToken(_ urlString: String?, perform: @escaping (_ csrfToken: String) -> Void) {
        
        let csrfURLString = urlString ?? rootURLString + "/accounts/login/"
        print(csrfURLString)
        
        Alamofire.request(csrfURLString)
            .validate()
            .responseData { response in
                guard response.result.isSuccess else {
                    print("error during csrf request")
                    return
                }
                guard   let headerFields = response.response?.allHeaderFields as? [String: String],
                        let URL = response.request?.url else {
                    print("error setting header fields")
                    return
                }
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: URL)
                guard cookies.count > 0 else {
                    print("no cookies retrieved")
                    return
                }
                for cookie in cookies {
                    guard cookie.name == "csrftoken" else {
                        print("no CSRF token retrieved")
                        return
                    }
                    let csrfToken = cookie.value
                    print("retrieved CSRF Token: ", csrfToken)
                    perform(csrfToken)
                }
                //print("request : \(response.request)")
                //print("request.response : \(response.response)")
                //print("request.result : \(response.result)")
        }
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
    
    func formatDateStringForServer(_ dateToFormat: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = KIITFConnection.serverDateFormat
        return dateFormatter.string(from: dateToFormat)
    }
    
    func dateFromJSONString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = KIITFConnection.serverDateFormat
        return dateFormatter.date(from: dateString)
    }
    
    // MARK - ACCOUNT FUNCTIONALITY
    
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
                    
                    self.setLoginFlag(email: email)
                    callback(true)
                    
                    /*if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                     print("Data: \(utf8Text)")
                     }*/
            }
        
        }
    }
    
    func logoutRequest(callback: @escaping (_ logoutSuccess: Bool) -> Void) {
        
        let logoutURLString = rootURLString + "/accounts/logout/"
        
        Alamofire.request(logoutURLString, method: .get)
            .validate()
            .responseData { response in
                guard response.result.isSuccess else {
                    print("error attempting to logout")
                    callback(false)
                    return
                }
                
                print("request : \(response.request)")
                print("request.response : \(response.response)")
                print("request.result : \(response.result)")
                
                self.clearLoginFlag()
                callback(true)
        }
        
    }
    
    func setLoginFlag(email: String) {
        UserDefaults.standard.set(true, forKey: KIITFConnection.loginFlagKey)
        UserDefaults.standard.set(email, forKey: KIITFConnection.accountKey)
    }
    
    func clearLoginFlag() {
        UserDefaults.standard.set(false, forKey: KIITFConnection.loginFlagKey)
        UserDefaults.standard.set(nil, forKey: KIITFConnection.accountKey)
    }
    
    func isUserLoggedIn() -> Bool {
        guard let loginFlag = UserDefaults.standard.value(forKey: KIITFConnection.loginFlagKey) as? Bool else {
            return false
        }
        return loginFlag
    }
    
    func userAccountEmail() -> String? {
        guard let accountEmail = UserDefaults.standard.value(forKey: KIITFConnection.accountKey) as? String else {
            return nil
        }
        return accountEmail
    }
    
    
    // MARK - CONTACTS

    func getContacts(callback: @escaping (_ contactList: [KIITFContact]?, _ isSuccessful: Bool) -> Void) {
        
        print("Executing getContacts()")
        
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
                        let contactLastCommunicationDateAsString = contactJSON["last_communication"].string,
                        let contactNextCommunicationDateAsString = contactJSON["next_communication"].string
                else {
                    print("error getting contact data from JSON")
                    continue
                }
                
                let contactLastCommunicationDate = self.dateFromJSONString(contactLastCommunicationDateAsString)
                let contactNextCommunicationDate = self.dateFromJSONString(contactNextCommunicationDateAsString)
                let contactCommunicationFrequency = CommunicationFrequency.frequencyFrom(minutes: contactCommunicationFrequencyInMinutes)
                
                let contact = KIITFContact(contactName, id: contactID, notes: contactNotes, communicationFrequency: contactCommunicationFrequency, lastCommunicationDate: contactLastCommunicationDate, nextCommunicationDate: contactNextCommunicationDate)
                
                contactsList.append(contact)
            }
            
            print("contacts received:")
            for contact in contactsList {
                print(contact.name)
            }
            
            callback(contactsList, true)
        }
        
    }
    
    func createContact(contact: KIITFContact, callback: @escaping (_ requestSuccess: Bool) -> Void) {
        
        print("Executing createContact()")
        
        let createContactURLString = rootURLString + "/contacts/"
        let crsfURLString = rootURLString
        
        performWithCSRFToken(crsfURLString){ (csrfToken: String) -> Void in
            
            let myParameters: [String: Any] = [
                "name": contact.name,
                "notes": contact.notes,
                "communication_frequency": contact.communicationFrequency.inMinutes,
                "last_communication": self.formatDateStringForServer(contact.lastCommunicationDate),
                "next_communication": self.formatDateStringForServer(contact.nextCommunicationDate),
                "csrfmiddlewaretoken": csrfToken
            ]
            
            Alamofire.request(createContactURLString, method: .post, parameters: myParameters, encoding: URLEncoding.default, headers: ["referer": crsfURLString])
                .validate()
                .responseData { response in
                    guard response.result.isSuccess else {
                        print("error creating contact \(contact.name)")
                        callback(false)
                        return
                    }
                    
                    print("request : \(response.request)")
                    print("request.response : \(response.response)")
                    print("request.result : \(response.result)")
                    
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                    }
                    
                    callback(true)
            }
            
        }
    }
    
    func updateContact(contact: KIITFContact, callback: @escaping (_ requestSuccess: Bool) -> Void) {
        
        print("Executing updateContact()")
        
        let updateContactURLString = rootURLString + "/contacts/" + contact.id + "/"
        let crsfURLString = rootURLString
        
        print(updateContactURLString)
        
        performWithCSRFToken(crsfURLString){ (csrfToken: String) -> Void in
            
            print("performing update w/ CSRF Token")
            
            let myParameters: [String: Any] = [
                "name": contact.name,
                "notes": contact.notes,
                "communication_frequency": contact.communicationFrequency.inMinutes,
                "last_communication": self.formatDateStringForServer(contact.lastCommunicationDate),
                "next_communication": self.formatDateStringForServer(contact.nextCommunicationDate),
                "csrfmiddlewaretoken": csrfToken
            ]
            
            print(myParameters)
            
            Alamofire.request(updateContactURLString, method: .patch, parameters: myParameters, encoding: URLEncoding.default, headers: ["referer": crsfURLString, "origin": crsfURLString, "x-csrftoken": csrfToken])
                .validate()
                .responseData { response in
                    
                    print("request.result.debugdescription : \(response.debugDescription)")
                    
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                    }
                    
                    guard response.result.isSuccess else {
                        print("error editing contact \(contact.name)")
                        callback(false)
                        return
                    }
                    
                    callback(true)
            }
        }
    }
    
    func deleteContact(contact: KIITFContact, callback: @escaping (_ requestSuccess: Bool) -> Void) {
        
        print("Executing deleteContact()")
        
        let deleteContactURLString = rootURLString + "/contacts/" + contact.id + "/"
        let crsfURLString = rootURLString
        
        print(deleteContactURLString)
        
        performWithCSRFToken(crsfURLString){ (csrfToken: String) -> Void in
            
            print("performing delete w/ CSRF Token")
            
            let myParameters: [String: Any] = [
                "csrfmiddlewaretoken": csrfToken
            ]
            
            print(myParameters)
            
            Alamofire.request(deleteContactURLString, method: .delete, parameters: myParameters, encoding: URLEncoding.default, headers: ["referer": crsfURLString, "origin": crsfURLString, "x-csrftoken": csrfToken])
                .validate()
                .responseData { response in
                    
                    print("request.result.debugdescription : \(response.debugDescription)")
                    
                    if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)")
                    }
                    
                    guard response.result.isSuccess else {
                        print("error deleting contact \(contact.name)")
                        callback(false)
                        return
                    }
                    
                    print("contact deleted")
                    callback(true)
            }
        }
    }


}
