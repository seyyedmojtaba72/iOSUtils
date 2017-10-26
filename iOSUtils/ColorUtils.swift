//
//  ColorUtils.swift
//  LeBox
//
//  Created by Mojtaba on 3/2/17.
//  Copyright © 2017 Patrison LLC. All rights reserved.
//

import Foundation

public class ColorUtils {
    
    public static func getUIColorFromHex(hex: String) -> UIColor{
        
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var alphaString: String = "00"
        if (cString.characters.count < 6) {
            return UIColor.gray
        } else if (cString.characters.count > 6) {
            alphaString = cString.substring(to: cString.index(cString.startIndex, offsetBy: 2))
        }

        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        var red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        var green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        var blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        var alpha = CGFloat(1.0)
        if (cString.characters.count == 8){
            red = CGFloat((rgbValue & 0x00FF0000) >> 24) / 255.0
            green = CGFloat((rgbValue & 0x0000FF00) >> 16) / 255.0
            blue = CGFloat((rgbValue & 0x000000FF) >> 8) / 255.0
            alpha = CGFloat(UInt8(alphaString, radix:16)!) / 255.0
        }
        
        //print("[getUIColorFromHex] red: \(red), green: \(green), blue: \(blue), alpha: \(alpha)")
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        
    }
    
    public static func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public static func imageWithGradient2() -> UIImage {
        
        let size = CGSize(width: 1, height: 250)
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        let context = UIGraphicsGetCurrentContext()
        let img = UIImage()
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations:[CGFloat] = [0.0, 1.0]
        
        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        let colors = [top, bottom] as CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        
        let startPoint = CGPoint(x: img.size.width/2, y: 0)
        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    public static func imageWithGradient(colors: [CGColor], locations: [CGFloat]) -> UIImage {
        
        
        let size = CGSize(width: 1, height: 250)
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        let context = UIGraphicsGetCurrentContext()
        let img = UIImage()
        img.draw(at: CGPoint(x: 0, y: 0))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        let startPoint = CGPoint(x: size.width, y: 0)
        let endPoint = CGPoint(x: size.width, y: size.height)
        
        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    
    public static func getGradientFromColors(colors: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        return gradient
    }
    
    public static func gradientView(view: UIView, colors: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    public static func tintedImage(image: UIImage, color: UIColor) -> UIImage {
        let imageSize: CGSize = image.size
        let imageScale: CGFloat = image.scale
        let contextBounds: CGRect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, imageScale)
        UIColor.black.setFill()
        UIRectFill(contextBounds)
        image.draw(at: CGPoint.zero)
        let imageOverBlack: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        color.setFill()
        UIRectFill(contextBounds)
        
        imageOverBlack.draw(at: CGPoint.zero, blendMode: .multiply, alpha: 1)
        image.draw(at: CGPoint.zero, blendMode: .destinationIn, alpha: 1)
        
        let finalImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return finalImage
    }
}
