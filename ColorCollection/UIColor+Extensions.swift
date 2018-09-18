//
//  UIColor+Extensions.swift
//  ColorCollection
//
//  Created by Adland Lee on 9/17/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var randomRGB: UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class var randomHSV: UIColor {
        let hue = CGFloat(drand48())
        let saturation = CGFloat(0.5)
        let brightness = CGFloat(0.95)
        let alpha = CGFloat(1.0)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    var hue: CGFloat {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getHue(&hue,
                    saturation: &saturation,
                    brightness: &brightness,
                    alpha: &alpha)
        
        return hue
    }
}

extension UIColor: Comparable {
    public static func < (lhs: UIColor, rhs: UIColor) -> Bool {
        return lhs.hue < rhs.hue
    }
}
