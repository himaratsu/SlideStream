//
//  SlideParser.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/07/06.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

class SlideParser {
   
    func parse(json: Array<[String:AnyObject]>) -> [Slide] {
        var slides = [Slide]()
        
        for dict in json {
            if let title = dict["title"] as? String,
                let link = dict["link"] as? String {
                    println("title: \(title)")
                    println(link)
                    
                    let description = dict["description"] as? String ?? ""
                    let hatebuCount = dict["hatebu_count"] as? Int ?? 0
                    let siteName = dict["sitename"] as? String ?? ""
                    let source = SourceType(rawValue: siteName) ?? .NotFound
                    let imageUrl = dict["slide_base_image_url"] as? String ?? ""
                    let totalCount: Int
                    if let count = dict["total_count"] as? Int {
                        totalCount = count
                    }
                    else {
                        totalCount = 0
                    }
                    let postdate = dict["postdate"] as? String ?? ""
                    
                    let slide = Slide(title: title,
                        link: link,
                        source: source,
                        imageUrl: imageUrl,
                        hatebu: hatebuCount,
                        totalCount: totalCount)
                    
                    slides.append(slide)
            }
            
        }
        
        return slides
    }
    
}
