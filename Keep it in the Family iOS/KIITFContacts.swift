//
//  Contacts.swift
//  Keep it in The Family iOS
//
//  Created by KENNETH VACZI on 9/13/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import Foundation

/*
struct KIITFContactList {
    public var contacts: [KIITFContact] = []
}

extension KIITFContactList : Sequence {
    
    func generate() -> IteratorProtocol {
        return KIITFContactListGenerator(contactList: self)
    }
    
    struct KIITFContactListGenerator : IteratorProtocol {
        var contactList: KIITFContactList
        var index = 0
        
        init(contactList: KIITFContactList) {
            self.contactList = contactList
        }
        
        mutating func next() -> KIITFContact? {
            return index < contactList.contacts.count ? contactList.contacts[index + 1] : nil
        }
    }
 
}
*/

struct KIITFContact {
    
    var name: String
    let id: String
    var notes: String
    var communicationFrequency: CommunicationFrequency
    var lastCommunicationDate: Date
    
    init(_ name: String, id: String, notes: String?, communicationFrequency: CommunicationFrequency?, lastCommunicationDate: Date?) {
        self.name = name
        self.id = id
        self.notes = (notes != nil ? notes! : "")
        self.communicationFrequency = (communicationFrequency != nil ? communicationFrequency! : .monthly)
        self.lastCommunicationDate = (lastCommunicationDate != nil ? lastCommunicationDate! : Date(timeIntervalSinceNow: 0))
    }

    public func communicationFrequencyInMinutes() -> Int {
        switch communicationFrequency {
        case .daily:
            return 1440
        case .weekly:
            return 10080
        case .biweekly:
            return 20160
        case .monthly:
            return 43200
        case .quarterly:
            return 132480
        case .biannually:
            return 262800
        case .yearly:
            return 525600
        }
    }
    
    static func calculateCommunicationFrequency(_ frequencyInMinutes: Int) -> CommunicationFrequency {
        switch frequencyInMinutes {
        case 1440:
            return .daily
        case 10080:
            return .weekly
        case 20160:
            return .biweekly
        case 43200:
            return .monthly
        case 132480:
            return .quarterly
        case 262800:
            return .biannually
        default:
            return .yearly
        }
    }
}

enum CommunicationFrequency {
    case daily
    case weekly
    case biweekly
    case monthly
    case quarterly
    case biannually
    case yearly
}
