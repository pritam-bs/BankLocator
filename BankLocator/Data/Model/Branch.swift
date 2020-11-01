//
//  Branch.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import UIKit

//“lat” — latitude “lon” — longitude “n” — name
//“a” — address
//“t” — type
//“r” — region
//“av” — availability (optional)
//“i” — info (applicable only for branches)
//“ncash” — no cash (applicable only for branches)
//“cs” — has a coin station (applicable only for branches)

enum BranchType: Int, Codable {
  case branch = 0
  case atm = 1
  case bna = 2
  
  init(id: Int) {
    guard let type = BranchType(rawValue: id) else {
      self = .branch
      return
    }
    self = type
  }
  
  var name: String {
    switch self {
    case .branch:
      return "Branch"
    case .atm:
      return "ATM"
    case .bna:
      return "BNA"
    }
  }
  
  var alias: String {
    switch self {
    case .branch:
      return "BR"
    case .atm:
      return "A"
    case .bna:
      return "R"
    }
  }
  
  var backgroundColor: UIColor {
    switch self {
    case .branch:
        return UIColor(named: "branch") ?? UIColor.gray
    case .atm:
        return UIColor(named: "atm") ?? UIColor.gray
    case .bna:
        return UIColor(named: "bna") ?? UIColor.gray
    }
  }
}

struct Branch: Codable {
    let type: BranchType
    let name, address: String
    let availability, region: String?
    let isNoCash: Bool?
    let latitude, longitude: Double
    let info: String?
    let hasCoinStation: Bool?
    let uuid = UUID()
    
    enum CodingKeys: String, CodingKey {
        case type = "t"
        case name = "n"
        case address = "a"
        case availability = "av"
        case region = "r"
        case isNoCash = "ncash"
        case latitude = "lat"
        case longitude = "lon"
        case info = "i"
        case hasCoinStation = "cs"
    }
}

extension Branch: Hashable, Equatable {
    static func == (lhs: Branch, rhs: Branch) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

typealias BranchList = [Branch]
