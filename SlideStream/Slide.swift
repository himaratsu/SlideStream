//
//  Slide.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

enum SourceType: String {
    case SlideShare = "slideshare"
    case SpeakerDeck = "Speaker Deck"
    case NotFound = "not found"
}

class Slide {
   
    let title: String
    let link: String
    let source: SourceType
    let imageBaseUrl: String
    let hatebu: Int
    let totalCount: Int
    
    init(title: String, link: String, source: SourceType, imageUrl: String, hatebu: Int, totalCount: Int) {
        self.title = title
        self.link = link
        self.source = source
        self.imageBaseUrl = imageUrl
        self.hatebu = hatebu
        self.totalCount = totalCount
    }
    
    func slideThumbUrl() -> String {
        return slideUrl(0) ?? ""
    }
    
    func slideUrl(index: Int) -> String? {
        switch source {
        case .SlideShare:
            let replaceString = self.imageBaseUrl.stringByReplacingOccurrencesOfString("#No",
                withString: "\(index+1)",
                options: [],
                range: nil)
            return replaceString
        case .SpeakerDeck:
            let replaceString = self.imageBaseUrl.stringByReplacingOccurrencesOfString("#No",
                withString: "\(index)",
                options: [],
                range: nil)
            return replaceString
        case .NotFound:
            return nil
        }
    }
    
}
