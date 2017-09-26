//
//  UIController.swift
//  TextViewTransform
//
//  Created by james rochabrun on 9/21/17.
//  Copyright © 2017 james rochabrun. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {
    
    func getFrameForCard(type: CardType) -> CGRect {
        
        let w: CGFloat = type == .flatLandscape || type == .foldedLandscape ? self.containerView.frame.size.width * 0.7 : self.containerView.frame.size.width * 0.5
        let h: CGFloat = type == .flatLandscape || type == .foldedLandscape ? self.containerView.frame.size.height * 0.5 : self.containerView.frame.size.height * 0.7
        let x: CGFloat = (self.containerView.frame.size.width - w) / 2
        let y: CGFloat = (self.containerView.frame.size.height - h) / 2
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    func getFrameForTextViewCard(type: CardType) -> CGRect {
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var h: CGFloat = 0
        var w: CGFloat = 0
        
        if type == .flatPortrait || type == .flatLandscape {
            w = self.cardView.frame.size.width * 0.5
            x = 0//(self.cardView.frame.size.width - w) / 2
            h = self.cardView.frame.size.height * 0.5
            y = (self.cardView.frame.size.height - h) / 2 + 10
            
        } else if type == .foldedLandscape {
            
            //here is where you can get ideas for position
            let halfCardWidth = self.cardView.frame.size.width / 2
            
            w = halfCardWidth * 0.7
            h = self.cardView.frame.size.height * 0
            x = (halfCardWidth - w) / 2 //+ halfCardWidth
            y = (self.cardView.frame.size.height - h) / 2
            
        } else if type == .foldedPortrait {
            
            //here is where you can get ideas for position
            let halfCardHeight = self.cardView.frame.size.height / 2
            
            w = self.cardView.frame.size.width * 0.4
            h = self.cardView.frame.size.height * 0.5
            x = 55//(self.cardView.frame.size.width - w) / 2
           // y = (halfCardHeight - h) / 2 + halfCardHeight
            y = halfCardHeight + 50
        }
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    func getFrameForlineInCard(type: CardType) -> CGRect {
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        var h: CGFloat = 0
        var w: CGFloat = 0
        if type == .foldedPortrait {
            h = 3
            w = self.cardView.frame.size.width
            x = 0
            y = (self.cardView.frame.size.height - h) / 2
            return CGRect(x: x, y: y, width: w, height: h)
        } else if type == .foldedLandscape {
            h = self.cardView.frame.height
            w = 3
            x = (self.cardView.frame.size.width - w) / 2
            y = 0
            return CGRect(x: x, y: y, width: w, height: h)
        }
        return CGRect.zero
    }
    //mariano
    
    fileprivate func applyScale(scale: CGFloat, toView view: UIView) {
        view.contentScaleFactor = scale
        view.layer.contentsScale = scale
        for subview in view.subviews {
            self.applyScale(scale: scale, toView: subview)
        }
    }
    
//    func scaleCard() {
//
//        var extraPaddingX: CGFloat = 0
//        var extraPaddingY: CGFloat = 0
//        var finalScale = self.scale
//
//        switch self.cardType {
//        case .flatPortrait:
//            extraPaddingX = self.cardView.frame.origin.x
//            extraPaddingY = self.cardView.frame.origin.y + 50 //?
//        case .flatLandscape:
//            extraPaddingX = self.cardView.frame.origin.x
//            extraPaddingY = self.cardView.frame.origin.y
//
//        case .foldedPortrait:
//
//            let halfOfCardHeight = self.cardView.frame.size.height / 2
//            //check the textview y coordinate system
//            let isFirstInneFace = self.textView.frame.origin.y < halfOfCardHeight
//            extraPaddingX = self.cardView.frame.origin.x
//            extraPaddingY = isFirstInneFace ?  self.cardView.frame.origin.y : self.cardView.frame.origin.y + halfOfCardHeight
//
//        case .foldedLandscape:
//
//            let halfOfCardWidth = self.cardView.frame.size.width / 2
//            let isFirstInnerFace = self.textView.frame.origin.x < halfOfCardWidth
//
//            //check the textview x coordinate system
//            //adpat the scale to the new width
//            finalScale = self.scale * 2
//            extraPaddingX = isFirstInnerFace ? self.cardView.frame.origin.x : self.cardView.frame.origin.x + halfOfCardWidth
//            extraPaddingY = self.cardView.frame.origin.y
//
//        }
    
//
//        //MARK: For extra padding x or y use the paddingX or y paremeter
//        self.zoomIn(containerView: self.containerView, in: self.view, paddingX: 0, paddingY: 0, scale: finalScale, extraPaddingX: extraPaddingX, extraPaddingY: extraPaddingY)
//    }
//
//

}





protocol Displayable {
}

extension UIView: Displayable { }
extension Displayable where Self: UIView {
    
    func animate(duration: CGFloat, delay: CGFloat, damping: CGFloat, velocity: CGFloat, options: UIViewAnimationOptions, transform: CGAffineTransform) {
        UIView.animate(withDuration: TimeInterval(duration),
                       delay: TimeInterval(delay),
                       usingSpringWithDamping: damping, //less is more bouncing 0 to 1
            initialSpringVelocity: velocity, //speed of animation
            options: options,//.curveEaseIn, not needed on damping
            animations: {
                self.transform = transform
        }, completion: nil)
    }
}



//good stuff
