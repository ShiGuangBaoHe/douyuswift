//
//  color_extension.swift
//  douyuzhibofang
//
//  Created by MacBook on 2018/8/8.
//  Copyright © 2018年 douyumeng. All rights reserved.
//

import UIKit


extension UIColor {
    
    convenience  init(r:CGFloat,g:CGFloat,b:CGFloat) {
        
        self.init(red: r/225.0, green: g/225.0, blue: b/225.0, alpha: 1.0)
    }
    //传入色值，转换成  r  g  b  颜色
    class func colorWithHexColor (colorHex:String) -> UIColor{
        
       var col:String!
        
        
       if colorHex.first == "#" {
            col = String(colorHex[colorHex.index(colorHex.startIndex, offsetBy: 1)..<colorHex.endIndex])
        }
        
        let scanner = Scanner(string:col)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        return UIColor(red: CGFloat(r) / 0xff, green:CGFloat(g) / 0xff, blue:  CGFloat(b) / 0xff, alpha: 1.0)

    }

}
