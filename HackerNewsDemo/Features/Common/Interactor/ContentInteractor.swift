//
//  NewsInteractor.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit

public protocol ContentInteractor : NSObjectProtocol {
    var output: ContentInteractorOutput? { get set }
    func fetch(type: ContentService.FetchType)
}


public protocol ContentInteractorOutput : NSObjectProtocol {
    func onLoadingContent(loading: Bool)
    func onSuccessContent(fetchType: ContentService.FetchType, newsObjects: [NewsObject])
    func onErrorContent()
}
