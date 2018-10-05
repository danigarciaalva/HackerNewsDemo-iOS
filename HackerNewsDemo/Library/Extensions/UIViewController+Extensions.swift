//
//  UIViewController+Extensions.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit


extension UIViewController {
    
    func inNavigationViewController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
    class func instantiateFromStoryboard() -> Self {
        return instantiateFromStoryboardHelper(self.typeName)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T
    {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else {
            fatalError("Storyboard must contain an InitialViewController")
        }
        return controller as! T
    }
}
