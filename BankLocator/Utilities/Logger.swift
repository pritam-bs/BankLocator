//
//  Logger.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import Foundation

class Logger {
    static func log(_ item: String) {
        #if DEBUG
        print(item)
        #endif
    }
}
