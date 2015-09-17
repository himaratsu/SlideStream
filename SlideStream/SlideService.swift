//
//  SlideService.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/07/06.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import Alamofire

private let host = "https://slide-stream.herokuapp.com" // prod

private let apiUrl = "\(host)/entries.json"
private let slidesApiUrl = "\(host)/slides"
private let refreshApiUrl = "\(host)/refresh"

class SlideService {
   
    var isLoaded = [Mode:Bool]()
    var slides = [Mode:[Slide]]()
    
    var slide: Slide?   // URLでリクエストする時用
    
    func requestSlides(mode: Mode, completionHandler:([Slide]?, NSError?) -> Void) {
        
        isLoaded[mode] = false
        slides[mode] = [Slide]()
        
        var params = ["mode": mode.mode]
        if mode == .Latest {
            params["sort"] = "latest"
        }
        
        Alamofire.request(.GET,
            apiUrl,
            parameters: params,
            encoding: ParameterEncoding.URL)
            .response { [weak self] (req, res, data, error) -> Void in
                
                 print(req?.URL)
                
                if let error = error {
                    print(error)
                } else {
                    if let json = try! NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.AllowFragments) as? Array<[String:AnyObject]> {
                        
                        let parser = SlideParser()
                        let slides = parser.parse(json)
                        
                        self?.slides[mode] = slides
                        self?.isLoaded[mode] = true
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(slides, nil)
                        })
                        
                    }
                }
        }
    }
    
    func requestSlide(url: String, completionHandler:(Slide?, NSError?) -> Void) {
        
        guard let siteName = Util.urlToSiteName(url) else {
            completionHandler(nil, NSError(domain: "domain not correct", code: 9000, userInfo: nil))
            return
        }
        
        let params = ["sitename": siteName, "url": url]
        
        Alamofire.request(.GET,
            slidesApiUrl,
            parameters: params,
            encoding: ParameterEncoding.URL)
        .response { [weak self] (req, res, data, error) -> Void in
            
            print("##### \(req?.URL)")
            
            if let error = error {
                print(error)
            }
            else {
                if let json = try! NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject] {
                        
                        let parser = SingleSlideParser()
                        if let slide = parser.parse(json) {
                            self?.slide = slide
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completionHandler(slide, nil)
                            })
                        }
                        
                }
            }

        }
    }
    
    func refreshSlideInfo(completionHandler:(Bool?, NSError?) -> Void) {
        
        Alamofire.request(.GET,
            refreshApiUrl,
            parameters: nil,
            encoding: ParameterEncoding.URL)
            .response { (req, res, data, error) -> Void in
                
                print("##### \(req?.URL)")
                
                if let error = error {
                    print(error)
                    completionHandler(nil, NSError(domain: "error", code: 999, userInfo: nil))
                }
                else {
                    completionHandler(true, nil)
                }
        }
    }

}
