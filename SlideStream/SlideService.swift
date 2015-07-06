//
//  SlideService.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/07/06.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import Alamofire

private let apiUrl = "http://slide-stream.herokuapp.com/entries.json"

class SlideService {
   
    func requestSlides(completionHandler:([Slide]?, NSError?) -> Void) {
        
        Alamofire.request(.GET,
            apiUrl,
            parameters: nil,
            encoding: ParameterEncoding.URL)
            .response { (req, res, data, error) -> Void in
                
                if let error = error {
                    println(error)
                }
                else {
                    if let json = NSJSONSerialization.JSONObjectWithData(data as! NSData,
                    options: NSJSONReadingOptions.AllowFragments,
                    error: nil) as? Array<[String:AnyObject]> {
                        
                        let parser = SlideParser()
                        let slides = parser.parse(json)
                        
                        completionHandler(slides, nil)
                        
                    }
                }
        }
    }

}
