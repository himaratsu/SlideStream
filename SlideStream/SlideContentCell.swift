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
        slideImageView.layer.cornerRadius = 1.0
        slideImageView.layer.masksToBounds = true
        slideImageView.layer.borderColor = UIColor.color(0xCCCCCC).CGColor
        slideImageView.layer.borderWidth = 0.5
        slideImageView.backgroundColor = UIColor.clearColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        slideImageView.image = nil
        slideImageView.sd_cancelCurrentImageLoad()
    }
    
    func configure(slideUrl: String) {
        slideImageView.loadImageURLWithEasingAnimation(slideUrl)
    }
    
}
