//
//  SlideCell.swift
//  SlideStream
//
//  Created by 平松　亮介 on 2015/06/30.
//  Copyright (c) 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

class SlideCell: UITableViewCell {

    @IBOutlet weak private var thumbImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var sourceLabel: UILabel!
    @IBOutlet weak private var hatebuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureSlide(slide: Slide) {
        titleLabel.text = slide.title
        sourceLabel.text = slide.source.rawValue
        hatebuLabel.text = "\(slide.hatebu) users"
    }

}
