//
//  PageProgressView.swift
//  SlideStream
//
//  Created by himara2 on 2015/07/12.
//  Copyright © 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

class PageProgressView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var progressLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame:frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        NSBundle.mainBundle().loadNibNamed("PageProgressView", owner: self, options: nil)
        
        contentView.frame = bounds;
        self.addSubview(contentView)
    }
    
    override func awakeFromNib() {
        backgroundView.layer.cornerRadius = 8.0
        backgroundView.layer.masksToBounds = true
    }
    
    func setCurrentPage(currentPage: Int, totalPage: Int) {
        progressLabel.text = "\(currentPage) / \(totalPage) 枚"
    }
    
    func showWithAnimation() {
        if self.alpha == 0 {
            UIView.animateWithDuration(0.5) { () -> Void in
                self.alpha = 1
            }
        }
    }
    
    func hideWithAnimation() {
        if self.alpha == 1 {
            UIView.animateWithDuration(0.3) { () -> Void in
                self.alpha = 0
            }
        }
    }

}
