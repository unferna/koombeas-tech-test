//
//  UIVIew+Extensions.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import UIKit

extension UIView {
    func addShadow(color: UIColor, blur: CGFloat, position: CGPoint, useCornerRadius: Bool = true, customRect: CGRect? = nil) {
        let rect: CGRect = customRect ?? bounds
        
        if useCornerRadius {
            layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).cgPath
        
        } else {
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
        
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: position.x, height: position.y)
        layer.shadowRadius = blur
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    func circle(customRadius: CGFloat? = nil) {
        if let radius = customRadius {
            layer.cornerRadius = radius
        
        } else {
            layer.cornerRadius = bounds.width / 2
        }
    }
}
