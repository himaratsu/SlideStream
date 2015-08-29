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
        slideImageView.backgroundColor = UIColor.clearColor()
    }
    
    func configure(slideUrl: String) {
        slideImageView.loadImageURLWithEasingAnimation(slideUrl)
    }
    
}
