//
//  Region.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import Foundation

struct Region {
    let name: String
    let Branchs: [Branch]
}

enum RegionName: String {
    case estonia = "Estonia"
    case latvia = "Latvia"
    case lithuania = "Lithuania"
}
