//
//  Theme.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit

class Theme {
    
    class Colors {
        
        static let shadow = UIColor(hex: 0xD9D9D9, alpha: 0.35)
        static let border = UIColor(hex: 0xEEEEEE)
        static let primary = UIColor(hex: 0x0a152a)
        static let secondary = UIColor(hex: 0x23527c)
    }
    
    class Fonts {
        
        enum ThemeFonts : String {
            case demiBold = "AvenirNext-DemiBold"
            case regular = "AvenirNext-Regular"
            case medium = "AvenirNext-Medium"
        }
        
        class func font(type: ThemeFonts, size: Int) -> UIFont {
            return UIFont(name: type.rawValue, size: CGFloat(size))!
        }
    }
}
