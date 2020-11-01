//
//  Region.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import Foundation

struct Country {
    let name: String
    let regions: [Region]
    let uuid = UUID()
}

enum CountryName: String {
    case estonia = "Estonia"
    case latvia = "Latvia"
    case lithuania = "Lithuania"
}

extension Country: Hashable, Equatable {
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
