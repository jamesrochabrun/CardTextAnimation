//
//  TextViewContainer.swift
//  TextViewTransform
//
//  Created by james rochabrun on 9/22/17.
//  Copyright © 2017 james rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol TextViewContainerDelegate: class {
    func passTextView(_ textViewContainer: TextViewContainer)
}

class TextViewContainer: UIView, UITextViewDelegate {
    
    weak var delegate: TextViewContainerDelegate?
    
    let textView: UITextView = {
        let tv = UITextView(frame: CGRect.zero)
        tv.layer.borderColor = UIColor.red.cgColor
        tv.layer.borderWidth = 0.2
        return tv
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let w = frame.width * 0.7
        let h = frame.height * 0.8
        let x = (frame.size.width - w) / 2
        let y = (frame.size.height - h) / 2
        
        textView.frame = CGRect(x: x, y: y, width: w, height: h)
        textView.delegate = self
        addSubview(textView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("FRAME :\(self.frame)")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.passTextView(self)
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        self.updateTextFont(textView: textView)
//    }
//
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print(textView.text)
        return true
    }
    
//    func updateTextFont(textView : UITextView) {
//
//        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero)) {
//            return
//        }
//
//        let textViewSize = textView.frame.size
//        let fixedWidth = textViewSize.width
//
//        let expectSize = textView.sizeThatFits(CGSize(width : fixedWidth, height : CGFloat(MAXFLOAT)));
//
//        var expectFont = textView.font;
//        if (expectSize.height > textViewSize.height) {
//            while (textView.sizeThatFits(CGSize(width : fixedWidth, height : CGFloat(MAXFLOAT))).height > textViewSize.height) {
//                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
//                textView.font = expectFont
//            }
//        }
//        else {
//            while (textView.sizeThatFits(CGSize(width : fixedWidth,height : CGFloat(MAXFLOAT))).height < textViewSize.height) {
//                expectFont = textView.font;
//                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
//            }
//            textView.font = expectFont;
//        }
//    }

}










