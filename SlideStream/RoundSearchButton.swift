//
//  RoundSearchButton.swift
//  SlideStream
//
//  Created by himara2 on 2015/08/23.
//  Copyright © 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

protocol RoundSearchButtonDelegate {
    func searchButtonDidTouched()
}

@IBDesignable
class RoundSearchButton: UIView {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    var delegate: RoundSearchButtonDelegate?
    
    // コードから初期化はここから
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    // xibからカスタムViewを読み込んで準備する
    private func comminInit() {
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "RoundSearchButton", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        addSubview(view)
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|",
            options:NSLayoutFormatOptions(rawValue: 0),
            metrics:nil,
            views: bindings))
        
    }
    
    @IBAction func searchButtonTouched(sender: AnyObject) {
        delegate?.searchButtonDidTouched()
    }
    
    override func awakeFromNib() {
        backgroundView.layer.cornerRadius = self.frame.size.width / 2
        backgroundView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
        backgroundView.layer.shadowOffset = CGSizeMake(0, 1)
        backgroundView.layer.shadowRadius = 0.5
        backgroundView.layer.shadowOpacity = 0.7
    }
}
