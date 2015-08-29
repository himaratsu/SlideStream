//
//  LoadingCell.swift
//  SlideStream
//
//  Created by himara2 on 2015/08/29.
//  Copyright © 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

class LoadingCell: UITableViewCell {

    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
    
    func configure() {
        activityIndicator.startAnimating()
    }

}
