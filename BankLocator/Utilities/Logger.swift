//
//  Logger.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import Foundation

class Logger {
    static func log(_ items: Any...) {
        #if DEBUG
        print(items)
        #endif
    }
}
