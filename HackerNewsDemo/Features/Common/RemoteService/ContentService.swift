//
//  NewsService.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

public class ContentService: NSObject {
    
    public enum FetchType : String{
        case news = "/v2/top-headlines?sources=hacker-news&apiKey=5adfd863c2234466a8f436de19dd73f1"
    }
    
    public func fetch(type: FetchType) -> Observable<APIResponse<NewsAPIResponse>> {
        return Alamofire.SessionManager.default.rx
            .responseJSON(HTTPMethod.get,
                          Urls.current + type.rawValue,
                          encoding: JSONEncoding.default)
            .mapObject(type: NewsAPIResponse.self)
    }
    
}

