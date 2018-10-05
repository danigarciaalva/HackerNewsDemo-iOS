//
//  CALayer+Extensions.swift
//  HackerNewsDemo
//
//  Created by Daniel Garcia Alvarado on 10/5/18.
//  Copyright © 2018 Dragonfly Labs. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addShadow() {
        self.cornerRadius = 6.0
        self.addShadow(color: UIColor.black)
    }
    
    func addLightShadow() {
        self.cornerRadius = 6.0
        self.addShadow(color: UIColor.black.withAlphaComponent(0.2))
    }
    
    func addShadow(color: UIColor) {
        self.shadowOffset = CGSize(width: 4.0, height: 4.0)
        self.shadowOpacity = 0.3
        self.shadowRadius = 6
        self.shadowColor = color.cgColor
        self.masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func removeShadow() {
        
    }
    
    func roundCorners(radius: CGFloat) {
        self.cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter{ $0.frame.equalTo(self.bounds) }
                .forEach{ $0.roundCorners(radius: self.cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first,
                sublayer.name == "_RoundedCorners" {
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = "_RoundedCorners"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
}
