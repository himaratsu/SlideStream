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
        let slides = [Slide]()
        
        for dict in json {
            let title = dict["title"] as? String ?? ""
            println("title: \(title)")
        }
        
        return slides
    }
    
}
