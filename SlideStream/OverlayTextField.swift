//
//  OverlayTextField.swift
//  SlideStream
//
//  Created by himara2 on 2015/08/23.
//  Copyright © 2015年 Ryosuke Hiramatsu. All rights reserved.
//

import UIKit

protocol OverlayTextFieldDelegate {
    func didSearchWithUrl(url: String)
}

class OverlayTextField: UIView, UITextFieldDelegate, InputHelperViewDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var noticeLabel: UILabel!

    var delegate: OverlayTextFieldDelegate?
    
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
        let nib = UINib(nibName: "OverlayTextField", bundle: bundle)
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
    
    func configure() {
        let helperView = InputHelperView()
        helperView.frame = CGRectMake(0, 0, frame.size.width, 60)
        helperView.delegate = self
        textField.inputAccessoryView = helperView
    }

    func show() {

    }
    
    func hideWithAnimation() {
        UIView.animateWithDuration(0.12, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.alpha = 0
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
    }

    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print(textField.text)
        
        let inputedText = (textField.text! as NSString).mutableCopy()
        inputedText.replaceCharactersInRange(range, withString: string)
        
        if let inputedText = inputedText as? String,
            let siteName = Util.urlToSiteName(inputedText) {
                if siteName == "slideshare" {
                    noticeLabel.text = "[slideshare] から検索"
                } else {
                    noticeLabel.text = "[Speaker Deck] から検索"
                }
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        hideWithAnimation()
        delegate?.didSearchWithUrl(textField.text!)
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hideWithAnimation()
    }
    
    
    // MARK: - InputHelperViewDelegate
    
    func helperViewDidTouched(text: String) {
        textField.text = text
    }
    
}
