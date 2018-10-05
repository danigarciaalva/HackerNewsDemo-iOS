//
//  WordpressContent.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit
import ObjectMapper

public class NewsAPIResponse: Mappable {
    var articles: [NewsObject] = []
    
    public required init?(map: Map) {
        
    }
    
    public func mapping(map: Map) {
        articles <- map["articles"]
    }
}
