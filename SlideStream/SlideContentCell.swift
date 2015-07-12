//
//  SlideContentCell.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/07/01.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit
import SDWebImage

class SlideContentCell: UITableViewCell {

    @IBOutlet weak private var slideImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        slideImageView.layer.cornerRadius = 4.0
        slideImageView.layer.masksToBounds = true
        slideImageView.layer.borderColor = UIColor.color(0xBBBBBB).CGColor
        slideImageView.layer.borderWidth = 1.0
        slideImageView.backgroundColor = UIColor.blackColor()
    }
    
    func configure(slideUrl: String) {
        print(slideUrl)
        slideImageView.sd_setImageWithURL(NSURL(string: slideUrl),
            completed: { (image, error, type, URL) -> Void in
                if error == nil {
                    self.slideImageView.alpha = 0
                    self.slideImageView.image = image
                    UIView.animateWithDuration(0.25,
                        animations: { () -> Void in
                            self.slideImageView.alpha = 1
                    })
                }
                else {
                    print(error!)
                }
        })
    }
    
}
