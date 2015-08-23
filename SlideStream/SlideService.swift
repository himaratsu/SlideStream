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
private let slidesApiUrl = "https://slide-stream.herokuapp.com/slides"

class SlideService {
   
    func requestSlides(mode: Mode, completionHandler:([Slide]?, NSError?) -> Void) {
        
        var params = ["mode": mode.rawValue]
        if mode == Mode.Latest {
            params["sort"] = "latest"
        }
        
        Alamofire.request(.GET,
            apiUrl,
            parameters: params,
            encoding: ParameterEncoding.URL)
            .response { (req, res, data, error) -> Void in
                
                 print(req?.URL)
                
                if let error = error {
                    print(error)
                }
                else {
                    if let json = try! NSJSONSerialization.JSONObjectWithData(data!,
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
    
    func requestSlide(url: String, completionHandler:(Slide?, NSError?) -> Void) {
        
        var params = ["sitename": "slideshare", "url": "http://www.slideshare.net/t26v0748/apple-watch-48652348"]
        
        
        Alamofire.request(.GET,
            slidesApiUrl,
            parameters: params,
            encoding: ParameterEncoding.URL)
        .response { (req, res, data, error) -> Void in
            
            if let error = error {
                print(error)
            }
            else {
                if let json = try! NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject] {
                        
                        let parser = SingleSlideParser()
                        if let slide = parser.parse(json) {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completionHandler(slide, nil)
                            })
                        }
                        
                }
            }

        }
    }

}
