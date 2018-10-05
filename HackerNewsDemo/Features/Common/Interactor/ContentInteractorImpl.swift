//
//  NewsInteractorImpl.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit
import RxSwift

extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?:"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}

class ContentInteractorImpl: NSObject, ContentInteractor {
    
    var output: ContentInteractorOutput?
    
    
    let remoteService = ContentService.init()
    let disposeBag = DisposeBag()
    
    func fetch(type: ContentService.FetchType) {
        self.output?.onLoadingContent(loading: true)
        remoteService.fetch(type: type)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map { (apiResponse) in
                return apiResponse.response!.articles
            }
            .subscribe(onNext: { (newsObjects) in
                self.output?.onLoadingContent(loading: false)
                self.output?.onSuccessContent(fetchType: type, newsObjects: newsObjects)
            }, onError: { (error) in
                self.output?.onLoadingContent(loading: false)
                self.output?.onErrorContent()
            }).disposed(by: self.disposeBag)
    }
}
