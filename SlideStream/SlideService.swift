//
//  SlideService.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/07/06.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import Alamofire

private let apiUrl = "https://slide-stream.herokuapp.com/entries.json"

class SlideService {
   
    func requestSlides(mode: Mode, completionHandler:([Slide]?, NSError?) -> Void) {
        
        Alamofire.request(.GET,
            URLString: apiUrl,
            parameters: ["mode": mode.rawValue],
            encoding: ParameterEncoding.URL)
            .response { (req, res, data, error) -> Void in
                
                 print(req?.URL)
                
                if let error = error {
                    print(error)
                }
                else {
                    if let json = try! NSJSONSerialization.JSONObjectWithData(data as! NSData,
                    options: NSJSONReadingOptions.AllowFragments) as? Array<[String:AnyObject]> {
                        
                        let parser = SlideParser()
                        let slides = parser.parse(json)
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(slides, nil)
                        })
                        
                    }
                }
        }
    }

}
