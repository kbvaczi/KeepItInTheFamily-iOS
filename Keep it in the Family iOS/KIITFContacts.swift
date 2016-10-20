//
//  Contacts.swift
//  Keep it in The Family iOS
//
//  Created by KENNETH VACZI on 9/13/16.
//  Copyright © 2016 KENNETH VACZI. All rights reserved.
//

import Foundation

struct KIITFContact {
    
    var name: String
    let id: String
    var notes: String
    var communicationFrequency: CommunicationFrequency
    var lastCommunicationDate: Date
    
    var nextCommunicationDate: Date {
        get {
            return (lastCommunicationDate + TimeInterval(communicationFrequencyInMinutes()))
        }
    }
    
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

enum CommunicationFrequency: String {
    
    case daily
    case weekly
    case biweekly
    case monthly
    case quarterly
    case biannually
    case yearly
    
    static let allValues = [daily, weekly, biweekly, monthly, quarterly, biannually, yearly]
    static let allValuesRaw = ["Daily", "Weekly", "Biweekly", "Monthly", "Quarterly", "Biannually", "Yearly"]
    
    static var optionsForSelect: [[String:Any]] {
        get {
            var options: [[String: Any]] = []
            for value in self.allValues {
                options.append(["label": value.rawValue, "value": value])
            }
            return options
        }
    }
    
    var inMinutes: Int {
        get {
            switch self {
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
    }
}

class KIITFContactSectionInfo {
    let names = ["Name", "Communication Frequency", "Last Contact", "Notes"]
    
    func sectionNumberForName(name: String) -> Int {
        return names.index(of: name) ?? 99
    }
}
