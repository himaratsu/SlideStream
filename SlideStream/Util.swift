//
//  Util.swift
//  SlideStream
//
//  Created by himara2 on 2015/07/11.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class Util {
    class func urlToSiteName(url: String) -> String? {
        if let URL = NSURL(string: url),
            let host = URL.host {
                if host == "www.slideshare.net" {
                    return "slideshare"
                } else if host == "speakerdeck.com" {
                    return "Speaker Deck"
                } else {
                    return nil
                }
        } else {
            return nil
        }
    }
}

extension UIColor {
    class func color(hex: Int, alpha: Double = 1.0) -> UIColor {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0xFF00) >> 8) / 255.0
        let blue = Double((hex & 0xFF)) / 255.0
        
        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    class func defaultColor(alpha: Double = 1.0) -> UIColor {
        return UIColor.color(0x00aced, alpha: alpha)
    }
    
    class func defaultBGColor(alpha: Double = 1.0) -> UIColor {
        return UIColor.color(0xEBEBEB, alpha: alpha)
    }
}


extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}


extension NSObject {
    public class var className:String {
        get {
            return NSStringFromClass(self).componentsSeparatedByString(".").last!
        }
    }
}


extension String {
    func toDate() -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter.dateFromString(self)
    }
}


extension NSDate {
    func toSimpleString() -> String? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return dateFormatter.stringFromDate(self)
    }
}

extension UIImageView {
    func loadImageURLWithEasingAnimation(imageUrl: String) {
        SDWebImageManager.sharedManager().imageCache.queryDiskCacheForKey(imageUrl)
            { (image, SDImageCacheType) -> Void in
            
            if let image = image {
                self.image = image
            } else {
                self.loadImageWithURL(imageUrl)
            }
        }
    }
    
    private func loadImageWithURL(imageUrl: String) {
        self.sd_setImageWithURL(NSURL(string: imageUrl),
            completed: { (image, error, type, URL) -> Void in
                if error == nil {
                    self.alpha = 0
                    self.image = image
                    UIView.animateWithDuration(0.15,
                        animations: { () -> Void in
                            self.alpha = 1
                    })
                } else {
                    print("######load image error ####### \(URL)")
                }
        })
    }
}

extension UITableView {
    func registerCell<T: UITableViewCell>(type: T.Type) {
        let className = type.className
        let nib = UINib(nibName: className, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: className)
    }
    
    func dequeueCell<T: UITableViewCell>(type: T.Type, indexPath: NSIndexPath) -> T {
        return self.dequeueReusableCellWithIdentifier(type.className, forIndexPath: indexPath) as! T
    }
}
