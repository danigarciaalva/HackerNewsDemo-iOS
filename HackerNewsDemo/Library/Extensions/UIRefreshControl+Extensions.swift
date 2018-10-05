//
//  UIRefreshControl+Extensions.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit

import UIKit
extension UIRefreshControl {
    func beginRefreshingWithAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            
            if let scrollView = self.superview as? UIScrollView {
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - self.frame.height), animated: true)
            }
            self.beginRefreshing()
        }
    }
    
    func stopRefreshingWithAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            
            if let scrollView = self.superview as? UIScrollView {
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: true)
            }
            self.endRefreshing()
        }
    }
}
