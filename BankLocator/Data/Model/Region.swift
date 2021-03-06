//
//  Region.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import Foundation

struct Region {
    let name: String
    var branches: [Branch]
    let uuid = UUID()
}

extension Region: Hashable, Equatable {
    static func == (lhs: Region, rhs: Region) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
