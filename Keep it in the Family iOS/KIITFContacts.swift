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
    var nextCommunicationDate: Date
    
    var nextCommunicationDatePredicted: Date {
        get {
            return (lastCommunicationDate + TimeInterval(communicationFrequency.inSeconds))
        }
    }
    
    init(_ name: String, id: String, notes: String? = nil, communicationFrequency: CommunicationFrequency? = nil, lastCommunicationDate: Date? = nil, nextCommunicationDate: Date? = nil) {
        self.name = name
        self.id = id
        self.notes = (notes ?? "")
        
        let communicationFrequencyToStore = (communicationFrequency ?? .monthly)
        self.communicationFrequency = communicationFrequencyToStore
        
        let lastCommunicationDateToStore = (lastCommunicationDate ?? Date(timeIntervalSinceNow: 0))
        self.lastCommunicationDate = lastCommunicationDateToStore
        
        let nextCommunicationDateToStore = nextCommunicationDate ?? (lastCommunicationDateToStore + TimeInterval(communicationFrequencyToStore.inSeconds))
        self.nextCommunicationDate = nextCommunicationDateToStore
    }
    
}

enum CommunicationFrequency: String {
    
    case daily = "Daily"
    case weekly = "Weekly"
    case biweekly = "Biweekly"
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case biannually = "Biannually"
    case yearly = "Yearly"
    
    static let allValues = [daily, weekly, biweekly, monthly, quarterly, biannually, yearly]
    
    static let defaultValue = monthly
    
    static var allValuesRaw: [String] {
        get {
            var valuesRaw: [String] = []
            for value in allValues {
                valuesRaw.append(value.rawValue)
            }
            return valuesRaw
        }
    }
    
    //static let allValuesRaw = ["Daily", "Weekly", "Biweekly", "Monthly", "Quarterly", "Biannually", "Yearly"]
    
    static func frequencyFrom(minutes: Int) -> CommunicationFrequency {
        switch minutes {
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
    
    var inSeconds: Int {
        get {
            return self.inMinutes * 60
        }
    }
}

class KIITFContactSectionInfo {
    let names = ["Name", "Communication Frequency", "Last Contact", "Notes"]
    
    func sectionNumberForName(name: String) -> Int {
        return names.index(of: name) ?? 99
    }
}
