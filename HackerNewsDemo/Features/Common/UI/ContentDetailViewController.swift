//
//  NewsDetailViewController.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/2/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit
import WebKit
import DeckTransition
import TUSafariActivity

class ContentDetailViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var item: NewsObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let link = self.item?.link {
            if link != "" {
                self.titleLabel.text = self.item!.title
                self.webView.load(URLRequest(url: URL(string: link)!))
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onShareClick(_ sender: Any) {
        let secondActivityItem : NSURL = NSURL(string: self.item!.link)!
        let activity = TUSafariActivity()
        let activityViewController = UIActivityViewController(activityItems: [secondActivityItem], applicationActivities: [activity])
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIView)
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onCloseClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    class func launch(from: UIViewController, with item: NewsObject) {
        let this = ContentDetailViewController.instantiateFromStoryboard()
        this.item = item
        let transitionDelegate = DeckTransitioningDelegate()
        this.transitioningDelegate = transitionDelegate
        this.modalPresentationStyle = .custom
        from.present(this, animated: true, completion: nil)
    }
}
