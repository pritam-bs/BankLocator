//
//  ApiPath.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Foundation

//Estonia: https://www.swedbank.ee/finder.json
//Latvia: https://ib.swedbank.lv/finder.json
//Lithuania: https://ib.swedbank.lt/finder.json

struct ApiPath {
    static var domainForEstonia: String {
        #if DEBUG
        return "www.swedbank.ee"
        #else
        // TODO: Release domain for Estonia
        return "www.swedbank.ee"
        #endif
    }
    
    static var domainForLatvia: String {
        #if DEBUG
        return "ib.swedbank.lv"
        #else
        // TODO: Release domain for Latvia
        return "ib.swedbank.lv"
        #endif
    }
    
    static var domainForLithuania: String {
        #if DEBUG
        return "ib.swedbank.lt"
        #else
        // TODO: Release domain for Lithuania
        return "ib.swedbank.lt"
        #endif
    }
}
