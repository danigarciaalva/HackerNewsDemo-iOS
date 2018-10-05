//
//  NewsDataSource.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit

typealias RefreshHandler = (() -> Void)?
typealias ClickHandler = ((_ item: NewsObject) -> Void)?

class ContentDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    var items : [NewsObject] = [] {
        didSet {
            self.tableView.reloadData()
            self.refreshControl.stopRefreshingWithAnimation()
        }
    }
    weak var tableView: UITableView!
    var refreshHandler: RefreshHandler
    var clickHandler: ClickHandler
    
    init(tableView: UITableView,
         clickHandler: ClickHandler,
         refreshHandler: RefreshHandler) {
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(self.getEstimatedRowHeight())
        
        tableView.addSubview(self.refreshControl)
        self.refreshHandler = refreshHandler
        self.clickHandler = clickHandler
        self.tableView = tableView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.getIdentifier()) as! NewsTableViewCell
        cell.populate(newsObject: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ContentDataSource.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Theme.Colors.primary
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.refreshHandler?()
    }
    
    func startRefreshAnimation() {
        self.refreshControl.beginRefreshingWithAnimation()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.items[indexPath.row]
        self.clickHandler?(item)
    }
    
    func getIdentifier() -> String {
        preconditionFailure("Method not implemented")
    }
    
    func getEstimatedRowHeight() -> Float {
        preconditionFailure("Method not implemented")
    }
}
