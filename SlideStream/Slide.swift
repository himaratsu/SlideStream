//
//  Slide.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

enum SourceType: String {
    case SlideShare = "SlideShare"
    case SpeakerDock = "SpeakerDock"
    case NotFound = "not found"
}

class Slide {
   
    let title: String
    let link: String
    let source: SourceType
    let imageUrl: String
    let hatebu: Int
    let totalCount: Int
    
    init(title: String, link: String, source: SourceType, imageUrl: String, hatebu: Int, totalCount: Int) {
        self.title = title
        self.link = link
        self.source = source
        self.imageUrl = imageUrl
        self.hatebu = hatebu
        self.totalCount = totalCount
    }
    
}
