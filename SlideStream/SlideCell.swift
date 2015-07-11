//
//  SlideCell.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import SDWebImage

class SlideCell: UITableViewCell {

    @IBOutlet weak private var thumbImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var sourceLabel: UILabel!
    @IBOutlet weak private var hatebuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        thumbImageView.layer.cornerRadius = 3.0
        thumbImageView.layer.masksToBounds = true
        thumbImageView.layer.borderColor = UIColor.color(0xCCCCCC).CGColor
        thumbImageView.layer.borderWidth = 1.0
    }
    
    func configureSlide(slide: Slide, index:Int) {
        thumbImageView.sd_setImageWithURL(NSURL(string: slide.slideThumbUrl()),
            completed: { (image, error, type, URL) -> Void in
                if error == nil {
                    self.thumbImageView.alpha = 0
                    self.thumbImageView.image = image
                    UIView.animateWithDuration(0.25,
                        animations: { () -> Void in
                            self.thumbImageView.alpha = 1
                    })
                }
        })
        titleLabel.text = slide.title
        sourceLabel.text = slide.source.rawValue
        hatebuLabel.text = "\(slide.hatebu) users"
        
        if index % 2 == 0 {
            backgroundColor = UIColor.color(0xFCFCFC)
        }
        else {
            backgroundColor = UIColor.color(0xF2F2F2)
        }
    }

}
