//
//  NewsTableViewCell.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var realContentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        self.realContentView.layer.addLightShadow()
    }
    
    override func layoutSubviews() {
        self.realContentView.layer.addLightShadow()
    }
    
    func populate(newsObject: NewsObject) {
        self.titleLabel.text = newsObject.title
        self.descriptionLabel.text = newsObject.desc
        if newsObject.image != "" && self.contentImageView != nil {
            self.imageViewHeightConstraint.constant = 200.0
            self.contentImageView.alpha = 1.0
            self.contentImageView.sd_setImage(with: URL(string: newsObject.image)) { (image, error, _, _) in
                self.setNeedsLayout()
            }
        } else if self.contentImageView != nil {
            self.imageViewHeightConstraint.constant = 1.0
            self.contentImageView.alpha = 0.0
        }
    }
}
