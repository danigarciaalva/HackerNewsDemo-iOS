//
//  NewsObject.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit
import ObjectMapper

public class NewsObject: Mappable {
    public required init?(map: Map) {
        
    }
    

    var title: String = ""
    var desc: String = ""
    var link: String = ""
    var image: String = ""
    
    public func mapping(map: Map) {
        title <- map["title"]
        desc <- map["description"]
        image <- map["urlToImage"]
        link <- map["url"]
    }
}
