//
//  MenuViewController.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit


class MenuViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newsController = NewsViewController.instantiateFromStoryboard().inNavigationViewController()
        newsController.tabBarItem = UITabBarItem(title: Strings.Menu.localized(key: "menu_tab_news"), image: UIImage(named: "IconTabNews"), selectedImage: nil)
        
        self.viewControllers = [newsController]
        self.tabBar.barTintColor = Theme.Colors.primary
        self.tabBar.tintColor = UIColor.white
        self.tabBar.isTranslucent = false
        
        let attributesNormal = [
            NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.7),
            NSAttributedString.Key.font : Theme.Fonts.font(type: .regular, size: 12)
        ]
        
        let attributesSelected = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : Theme.Fonts.font(type: .regular, size: 12)
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: UIControl.State.normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: UIControl.State.selected)
    }
}
