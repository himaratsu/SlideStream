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
}

class Slide {
   
    let title: String
    let url: String
    let source: SourceType
    let imageUrl: String
    let hatebu: Int
    let contents: [String]
    
    init(title: String, url: String, source: SourceType, imageUrl: String, hatebu: Int, contents: [String]) {
        self.title = title
        self.url = url
        self.source = source
        self.imageUrl = imageUrl
        self.hatebu = hatebu
        self.contents = contents
    }
    
}
