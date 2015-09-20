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
    @IBOutlet weak private var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.startAnimating()
    }
    
    func configure(state: SlideService.LoadingState) {
        switch state {
        case .EnableNext:
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            messageLabel.hidden = true
        case .ItemOver:
            activityIndicator.hidden = true
            activityIndicator.stopAnimating()
            messageLabel.hidden = false
            messageLabel.text = "スライドは以上です。"
        case .NetworkError:
            activityIndicator.hidden = true
            activityIndicator.stopAnimating()
            messageLabel.hidden = false
            messageLabel.text = "通信に失敗しました。\nネットワーク環境の良いところで再度お試しください。"
        }
    }

}
