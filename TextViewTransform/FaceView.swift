//
//  FaceView.swift
//  TextViewTransform
//
//  Created by james rochabrun on 9/22/17.
//  Copyright © 2017 james rochabrun. All rights reserved.
//

import Foundation
import UIKit

protocol FaceViewDelegate: class {
    func passTextViewFromFace(_ textViewContainer: TextViewContainer)
}

class FaceView: UIView, TextViewContainerDelegate {
    
    weak var delegate: FaceViewDelegate?
    var textViewContainer: TextViewContainer  = {
        let v = TextViewContainer(frame: CGRect.zero)
        return v
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let w = frame.width * 0.5
        let h = frame.height * 0.7
        let x = (frame.size.width - w) / 2
        let y = (frame.size.height - h) / 2
        
        textViewContainer = TextViewContainer(frame: CGRect(x: x, y: y, width: w, height: h))
        textViewContainer.delegate = self
        textViewContainer.layer.borderWidth = 0.2
        textViewContainer.layer.borderColor = UIColor.purple.cgColor
        addSubview(textViewContainer)
    }
    
    func passTextView(_ textViewContainer: TextViewContainer) {
        delegate?.passTextViewFromFace(textViewContainer)
    }
}
