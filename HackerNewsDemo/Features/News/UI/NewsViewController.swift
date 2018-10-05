//
//  NewsViewController.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit
import DeckTransition

class NewsViewController: UIViewController, ContentInteractorOutput {

    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    
    var dataSource : NewsDataSource?
    let interactor = ContentInteractorImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactor.output = self
        
        self.dataSource =  NewsDataSource(tableView: self.newsTableView, clickHandler: { (item) in
            ContentDetailViewController.launch(from: self, with: item)
        }) {
            self.interactor.fetch(type: .news)
        }
    
        self.interactor.fetch(type: .news)
    }
    
    func onLoadingContent(loading: Bool) {
        self.dataSource?.startRefreshAnimation()
    }
    
    func onErrorContent() {
        self.dataSource?.items = []
    }
    
    func onSuccessContent(fetchType: ContentService.FetchType, newsObjects: [NewsObject]) {
        self.dataSource?.items = newsObjects
    }
}
