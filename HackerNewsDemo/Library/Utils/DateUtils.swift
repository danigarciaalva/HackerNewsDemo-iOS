//
//  DateUtils.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/2/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit

class DateUtils: NSObject {

    class func parseDateFrom(string: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!)
    }
}
