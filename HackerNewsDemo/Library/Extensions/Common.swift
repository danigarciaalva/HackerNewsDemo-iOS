//
//  Common.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit

public protocol TypeName: AnyObject {
    static var typeName: String { get }
}

extension TypeName {
    public static var typeName: String {
        let type = String(describing: self)
        return type
    }
}

extension NSObject: TypeName {
    public class var typeName: String {
        let type = String(describing: self)
        return type
    }
}

extension  UIColor {
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1)
    }
    
    convenience init(hex: Int, alpha: Double) {
        self.init(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 8) & 0xff) / 255,
            blue: CGFloat(hex & 0xff) / 255,
            alpha: CGFloat(alpha))
    }
}
