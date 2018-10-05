//
//  Strings+Extensions.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit

class BaseStrings : TypeName {
    class func localized(key: String) -> String {
        let typeName = self.typeName
        return NSLocalizedString(key, tableName: typeName, comment: "")
    }
}
