//
//  Functions.swift
//  DeveloparsUtils
//
//  Created by Mojtaba on 3/2/17.
//  Copyright © 2017 DeveloPars. All rights reserved.
//

import Foundation

public class Functions {
    
    public static func md5(string: String) -> String {
        return string.md5()
    }
    
    public static func encodeURL(urlAddress: String) -> String {
        if let result = urlAddress.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed){
            return result
        }
        return ""
    }

    public static func getImageFromView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public static func reduceImageFileSize(image: UIImage, max_file_size_bytes: Int, quality: CGFloat) -> UIImage {
        print("[reduceImageFileSize] Reducing image file to \(max_file_size_bytes) bytes with \(quality) quality)")
        
        var image = image
        var data = UIImageJPEGRepresentation(image, quality)
        while ((data?.count)! > max_file_size_bytes){
            print("[reduceImageFileSize] Reducing...\((data?.count)!) > \(max_file_size_bytes))")
            
            image = (UIImage(data: data!)?.resized(withPercentage: quality))!
            data = UIImageJPEGRepresentation(image, quality)
        }
        
        return image
        
    }
    
    public static func putString(key: String, value: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    public static func getString(key: String, defaultValue: String? = "") -> String {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: key) != nil{
            return defaults.string(forKey: key)!
        }
        return defaultValue!
    }
    
    public static func putInt(key: String, value: Int) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    public static func getInt(key: String, defaultValue: Int? = 0) -> Int {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: key) != nil{
            return defaults.integer(forKey: key)
        }
        return defaultValue!
    }
    
    
    public static func putBoolean(key: String, value: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    public static func getBoolean(key: String, defaultValue: Bool? = false) -> Bool {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: key) != nil{
            return defaults.bool(forKey: key)
        }
        return defaultValue!
    }
    
    public static func persianDigits(text: String) -> String {
        var result = text
        let numbersDictionary = ["0": "۰", "1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        for item in numbersDictionary {
            result = result.replacingOccurrences(of: item.key, with: item.value)
        }
        return result
    }
    
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
