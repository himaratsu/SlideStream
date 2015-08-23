//
//  SingleSlideParser.swift
//  SlideStream
//
//  Created by himara2 on 2015/08/23.
//  Copyright © 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

class SingleSlideParser {
    
    func parse(json: [String:AnyObject]) -> Slide? {
        let dict = json
        if let title = dict["title"] as? String,
            let link = dict["link"] as? String {
                
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
                _ = dict["postdate"] as? String ?? ""
                
                let slide = Slide(title: title,
                    link: link,
                    source: source,
                    imageUrl: imageUrl,
                    hatebu: hatebuCount,
                    totalCount: totalCount)
                
                return slide
        }
        
        return nil
        
    }

}
