//
//  NewsDataSource.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/2/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit

class NewsDataSource: ContentDataSource {

    override func getIdentifier() -> String {
        return "NewsTableViewCell"
    }
    
    override func getEstimatedRowHeight() -> Float {
        return 350
    }
}
