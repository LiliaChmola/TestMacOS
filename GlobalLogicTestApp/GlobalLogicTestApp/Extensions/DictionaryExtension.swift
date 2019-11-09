//
//  DictionaryExtension.swift
//  GlobalLogicTestApp
//
//  Created by Chmola Lilia on 11/8/19.
//  Copyright © 2019 Lilia Chmola. All rights reserved.
//

import Foundation

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func dict2json() -> String {
        return json
    }
}
