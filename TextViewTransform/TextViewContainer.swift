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
        let h = frame.height * 0.4
        let x = (frame.size.width - w) / 2
        let y = (frame.size.height - h) / 2
        
        textView.frame = CGRect(x: x, y: y, width: w, height: h)
        textView.delegate = self
        textView.text = "Esto es un test"
        addSubview(textView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("FRAME :\(self.frame)")
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.passTextView(self)
        DispatchQueue.main.async {
            textView.selectAll(nil)
        }
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        self.updateTextFont(textView: textView)
//    }
//
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print(textView.text)
        return true
    }
    

}










