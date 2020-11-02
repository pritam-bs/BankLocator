//
//  PersistenceManager.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import Foundation

class PersistenceManager {
    static let shared = PersistenceManager()
    private let userDefaults: UserDefaults
    
    private init() {
        self.userDefaults = UserDefaults.standard
    }
    
    private let keyEstonia = Key<BranchList>(key: "key_estonia")
    public var estoniaBranchList: BranchList {
        get { return getValue(key: keyEstonia) ?? [] }
        set { setValue(value: newValue, for: keyEstonia) }
    }
    
    private let keyLatvia = Key<BranchList>(key: "key_latvia")
    public var latviaBranchList: BranchList {
        get { return getValue(key: keyLatvia) ?? [] }
        set { setValue(value: newValue, for: keyLatvia) }
    }
    
    private let keyLithuania = Key<BranchList>(key: "key_lithuania")
    public var lithuaniaBranchList: BranchList {
        get { return getValue(key: keyLithuania) ?? [] }
        set { setValue(value: newValue, for: keyLithuania) }
    }
    
    private func getValue<ValueType>(key: Key<ValueType>) -> ValueType? {
        if isSwiftCodableType(type: ValueType.self) || isFoundationCodableType(type: ValueType.self) {
                    return userDefaults.value(forKey: key.key) as? ValueType
                }
        
        
        guard let data = userDefaults.data(forKey: key.key) else {
                    return nil
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(ValueType.self, from: data)
                    return decoded
                } catch {
                    Logger.log(error.localizedDescription)
                }

                return nil
    }
    
    private func setValue<ValueType>(value: ValueType, for key: Key<ValueType>) {
        if isSwiftCodableType(type: ValueType.self) || isFoundationCodableType(type: ValueType.self) {
                    userDefaults.set(value, forKey: key.key)
                    return
                }
                
                do {
                    let encoder = JSONEncoder()
                    let encoded = try encoder.encode(value)
                    userDefaults.set(encoded, forKey: key.key)
                    userDefaults.synchronize()
                } catch {
                    Logger.log(error.localizedDescription)
                }
    }
    
    private func isSwiftCodableType<ValueType>(type: ValueType.Type) -> Bool {
            switch type {
            case is String.Type, is Bool.Type, is Int.Type, is Float.Type, is Double.Type:
                return true
            default:
                return false
            }
        }
    
    private func isFoundationCodableType<ValueType>(type: ValueType.Type) -> Bool {
            switch type {
            case is Date.Type:
                return true
            default:
                return false
            }
        }
}

public final class Key<ValueType: Codable> {
    let key: String
    public init(key: String) {
        self.key = key
    }
}
