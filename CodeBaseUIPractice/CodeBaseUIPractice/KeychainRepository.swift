//
//  KeychainRepository.swift
//  CodeBaseUIPractice
//
//  Created by 현수빈 on 2022/10/25.
//

import Foundation

// pincode, isTotalBalanceShow 저장
let USER_IDENTIFIER_STRING = "userIdentifier"
let APPLE_ID_TOKEN_STRING = "appleIdToken"
let NONCE_STRING = "nonce"

class KeyChainRepository {
    func addValueOnKeyChain(value: String, key: String) {
           let data = value.data(using: String.Encoding.utf8)!
            let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                        kSecAttrAccount: key,
                                        kSecValueData: data]
            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecSuccess {
                print("add success")
            } else if status == errSecDuplicateItem {
                updateValueOnKeyChain(value: value, key: key)
            } else {
                print("add failed")
            }
        }
        
    func updateValueOnKeyChain(value: String, key: String) {
            let data = value.data(using: String.Encoding.utf8)!
            let previousQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                                  kSecAttrAccount: key]
            let updateQuery: [CFString: Any] = [kSecValueData: data]
            let status = SecItemUpdate(previousQuery as CFDictionary, updateQuery as CFDictionary)
            if status == errSecSuccess {
                print("update complete")
            } else {
                print("not finished update")
                self.updateValueOnKeyChain(value2: value, key: key)
          
            }
        
    }
    func updateValueOnKeyChain(value2: String, key: String) {
        self.deleteValueOnKeyChain(key: key)
        self.addValueOnKeyChain(value: value2, key: key)
    }
    
    func readValueOnKeyChain(key: String) -> String? {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                    kSecAttrAccount: key,
                                    kSecReturnAttributes: true,
                                    kSecReturnData: true]
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess {
            print("read failed")
            return nil
        }
        guard let existingItem = item as? [String: Any] else { return nil }
        guard let data = existingItem[kSecValueData as String] as? Data else { return nil}
        guard let keyChain = String(data: data, encoding: .utf8) else { return nil }
        print("=== read \(key) keychain ===")
        print(keyChain)
        return keyChain
    }
    
    func deleteValueOnKeyChain(key: String) {
            let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                                kSecAttrAccount: key]
            let status = SecItemDelete(deleteQuery as CFDictionary)
            if status == errSecSuccess {
                print("remove key-data complete")
            } else {
                print("remove key-data failed")
            }
        }

}
