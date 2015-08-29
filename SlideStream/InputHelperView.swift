//
//  InputHelperView.swift
//  SlideStream
//
//  Created by himara2 on 2015/08/30.
//  Copyright © 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

protocol InputHelperViewDelegate: NSObjectProtocol {
    func helperViewDidTouched(text: String)
}

class InputHelperView: UIView {

    @IBOutlet weak private var previewLabel: UILabel!
    private var clipedText = ""
    weak var delegate: InputHelperViewDelegate?
    
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
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "InputHelperView", bundle: bundle)
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
        
        setUpGesture()
        configure()
    }
    
    
    private func setUpGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "helperViewTouched")
        addGestureRecognizer(tapGesture)
    }
    
    private func configure() {
        let pasteboard = UIPasteboard.generalPasteboard()
        if let pasteString = pasteboard.valueForPasteboardType("public.text") as? String {
            clipedText = pasteString
            previewLabel.text = pasteString
        } else {
            previewLabel.text = "-"
        }
    }
    
    func helperViewTouched() {
        delegate?.helperViewDidTouched(clipedText)
    }
}
