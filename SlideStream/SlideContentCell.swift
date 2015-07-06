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
        // Initialization code
    }
    
    func configure(slideUrl: String) {
        slideImageView.sd_setImageWithURL(NSURL(string: slideUrl))
    }
    
}
