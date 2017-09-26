
//  ViewController.swift
//  TextViewTransform
//
//  Created by james rochabrun on 9/19/17.
//  Copyright © 2017 james rochabrun. All rights reserved.
//

import UIKit

enum CardType1 {
    case flat
    case folded
}

enum CardType {
    case foldedPortrait
    case foldedLandscape
    case flatLandscape
    case flatPortrait
}

class ViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.borderColor = UIColor.red.cgColor
            containerView.layer.borderWidth = 5.0
        }
    }
    
    var isDownScale = false
    var cardType1: CardType1 = .folded
    
    var referenceFrame: CGRect = CGRect.zero
    
    @IBAction func scaleDown(_ sender: UIButton) {
        
        //get the new frame from a function
        self.isDownScale = !self.isDownScale
        
        if self.isDownScale {
            let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.cardView.transform = transform
        } else {
            self.cardView.transform = CGAffineTransform.identity
        }
    }
    
    var cardType: CardType = .foldedPortrait
    
    lazy var cardView: UIImageView = {
        
        let v = UIImageView(image: #imageLiteral(resourceName: "card"))
        v.frame = self.getFrameForCard(type: self.cardType)
        v.isUserInteractionEnabled = true
        v.layer.borderWidth = 2
        v.alpha = 0.7
        v.layer.borderColor = UIColor.magenta.cgColor
        v.clipsToBounds = true
        return v
    }()
    
    let overlay: UIView = {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = .black
        v.alpha = 0.5
        return v
    }()
    
    lazy var lineView: UIView = {
        let v = UIView(frame: self.getFrameForlineInCard(type: self.cardType))
        v.backgroundColor = .black
        return v
    }()
    
    lazy var textViewContainer: TextViewContainer  = {
        let v = TextViewContainer(frame: self.getFrameForTextViewCard(type: self.cardType))
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth = 1.5
        return v
    }()
    
    lazy var textViewContainer1: TextViewContainer  = {
        let v = TextViewContainer(frame: self.getFrameForTextViewCard(type: self.cardType))
        //  v.frame.origin.y += 10
        v.layer.borderColor = UIColor.darkGray.cgColor
        v.layer.borderWidth = 1.5
        return v
    }()
    
    //faceviews
    var faceview1: FaceView = {
        let fv = FaceView(frame: CGRect.zero)
        return fv
    }()
    
    var faceview2: FaceView = {
        let fv = FaceView(frame: CGRect.zero)
        return fv
    }()
    
    var yAxis: CGFloat = 0
    var keyBoardHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        //  self.setUpKeyBoardObservers()
        
        //        textViewContainer.delegate = self
        //        textViewContainer1.delegate = self
        
        //ADDSUBVIEWS
        self.containerView.addSubview(cardView)
        //   self.cardView.addSubview(lineView)
        //        self.cardView.addSubview(textViewContainer)
        //        self.cardView.addSubview(textViewContainer1)
        
        self.createCardForDownscale()
    }
    
    func createCardForDownscale() {
        
        var v1Frame = CGRect.zero
        var v2Frame = CGRect.zero
        
        if self.cardType == .foldedPortrait {
            
            v1Frame = CGRect(x: 0, y: 0, width: self.cardView.frame.width, height: self.cardView.frame.height / 2)
            v2Frame = CGRect(x: 0, y: v1Frame.height, width: self.cardView.frame.width, height: self.cardView.frame.height / 2)
            
        } else if self.cardType == .foldedLandscape {
            
            v1Frame = CGRect(x: 0, y: 0, width: self.cardView.frame.width / 2, height: self.cardView.frame.height)
            v2Frame = CGRect(x: v1Frame.width, y: 0, width: self.cardView.frame.width / 2, height: self.cardView.frame.height)
        }
        
        faceview1 = FaceView(frame: v1Frame)
        faceview1.layer.borderColor = UIColor.orange.cgColor
        faceview1.layer.borderWidth = 2
        faceview1.delegate = self
        
        faceview2 = FaceView(frame: v2Frame)
        faceview2.layer.borderWidth = 2
        faceview2.layer.borderColor = UIColor.green.cgColor
        faceview2.delegate = self
        
        self.cardView.addSubview(faceview1)
        self.cardView.addSubview(faceview2)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        self.zoomOut(self.animationduration)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    var delay : CGFloat = 0
    var damping: CGFloat = 0.95
    var velocity: CGFloat = 0
    var options: UIViewAnimationOptions = .curveEaseOut
    var animationduration: CGFloat = 0.75

    
    func zoomOut(_ duration: CGFloat) {
        let transform = CGAffineTransform.identity
        self.containerView.animate(duration: self.animationduration, delay: self.delay, damping: self.damping, velocity: self.velocity, options: [self.options], transform: transform)
       // self.overlay.removeFromSuperview()
    }
    
    //    func passTextView(_ textViewContainer: TextViewContainer) {
    //        var scale = self.view.frame.width / textViewContainer.frame.size.width
    //        defineTranslationForFlatCard(in: self.containerView, containerSuperview: self.view, scale: scale, cardFrame: self.cardView.frame, textLayerViewFrame: textViewContainer.frame, paddingX: 0, paddingY: 75)
    //    }
}

extension ViewController: FaceViewDelegate {
    
    func passTextViewFromFace(_ textViewContainer: TextViewContainer) {
                
        let container = textViewContainer.superview?.superview?.superview!
        if container?.transform == .identity {
            print("TTTT")
        } else {
            print("stop")
            return
        }
        
        let keyboardHeight = self.keyBoardHeight
        print("kk \(keyBoardHeight)")

        var fullScale = (self.view.frame.width / textViewContainer.frame.size.width)
        print("fullscale width \(fullScale)")

        let multiplier : CGFloat = 0.8
        var scale: CGFloat = fullScale * multiplier
        
        let totalWidth = self.view.frame.width
        let desiredWidth = totalWidth * multiplier
        let desiredPaddingX = (totalWidth - desiredWidth) / 2
        
        let totalHeight = self.view.frame.height
        let desiredHeight = totalWidth * multiplier
        let desiredPaddingY = (totalHeight - desiredHeight) / 2
        
        switch self.cardType1 {
        case .flat:
            defineTranslationForFlatCard(in: self.containerView, containerSuperview: self.view, scale: scale, cardFrame: self.cardView.frame, textLayerViewFrame: textViewContainer.frame, paddingX: desiredPaddingX, paddingY: (self.navigationController?.navigationBar.frame.maxY)!)
            
            self.view.addSubview(overlay)
        case .folded:
            if isDownScale {//no needed
                scale *= 2
            }
            
            let container = textViewContainer.superview?.superview?.superview!
            let cardView = textViewContainer.superview?.superview
            let faceView = textViewContainer.superview
//
//            print("faceview frame \(faceView?.frame)")
//            print("container frame \(container?.frame)")
//            print("cardView frame \(cardView?.frame)")
//            print("textcontainer \(textViewContainer.frame)")
            
            print("Textcontainer frame before scaled  \(textViewContainer.frame)")
            print("KMLAYER textcontainer before scaled \(textViewContainer.layer.frame)")
            
            var halfCardFaceX: CGFloat = 0
            var halfCardFaceY: CGFloat = 0
            let firstFaceCGPoint = CGPoint(x: 0, y: 0)
            let isPortrait = faceView!.frame.size.width > faceView!.frame.size.height
            
            if faceView?.frame.origin == firstFaceCGPoint {
                print("Yes this is the firts one")
            } else {
                if isPortrait {
                    halfCardFaceY += (faceView?.frame.height)!
                } else {
                    halfCardFaceX += (faceView?.frame.width)!
                }
            }
            print("HFX \(halfCardFaceX), HFY \(halfCardFaceY)")
            
            defineTranslationForFoldedCard(of: container!, in: self.view, scale: scale, cardFrame: (cardView?.frame)!, textLayerViewFrame: textViewContainer.frame, cardType: .flat, deltaHalfCardX: halfCardFaceX, deltaHalfCardY: halfCardFaceY, paddingX: desiredPaddingX, paddingY: desiredPaddingY, viewScaled: textViewContainer)
    
        }
    }
    
    //MARK: Folded means aka always scaled
    func defineTranslationForFoldedCard(of container: UIView, in supperView: UIView,  scale: CGFloat, cardFrame: CGRect, textLayerViewFrame: CGRect, cardType: CardType1, deltaHalfCardX: CGFloat, deltaHalfCardY: CGFloat, paddingX: CGFloat, paddingY: CGFloat, viewScaled: UIView) {
        let deltaX = (cardFrame.origin.x * scale) + ((textLayerViewFrame.origin.x + deltaHalfCardX) * scale / 2)
        let deltaY = (cardFrame.origin.y * scale) + ((textLayerViewFrame.origin.y + deltaHalfCardY) * scale / 2)
        self.zoomIn(containerView: container, in: supperView, paddingX: paddingX, paddingY: paddingY, scale: scale, extraPaddingX: deltaX, extraPaddingY: deltaY, scaledView: viewScaled)
    }
    //MARK: flatCard means aka always not scaled
    func defineTranslationForFlatCard(in container: UIView, containerSuperview: UIView, scale: CGFloat, cardFrame: CGRect, textLayerViewFrame: CGRect, paddingX: CGFloat, paddingY: CGFloat) {
        
        let deltaX = (cardFrame.origin.x + textLayerViewFrame.origin.x) * scale
        let deltaY = (cardFrame.origin.y + textLayerViewFrame.origin.y) * scale
        self.zoomIn(containerView: container, in: containerSuperview, paddingX: paddingX, paddingY: paddingY, scale: scale, extraPaddingX: deltaX, extraPaddingY: deltaY, scaledView: nil)
    }
    

    
    //main function do no touch
    func zoomIn(containerView: UIView, in superView: UIView, paddingX: CGFloat, paddingY: CGFloat, scale: CGFloat, extraPaddingX: CGFloat, extraPaddingY: CGFloat, scaledView: UIView?) {
        
        let superViewFrame: CGRect  = superView.frame
        let containerFrame: CGRect  = containerView.frame
        var finalCenter: CGPoint  = CGPoint.zero
        
        finalCenter.x = (superViewFrame.size.width - (containerFrame.size.width * scale) / 2.0 - paddingX ) + extraPaddingX
        finalCenter.y = (paddingY + (containerFrame.size.height * scale) / 2.0) - extraPaddingY
        
        let containerCenter: CGPoint  = containerView.center
        let deltaX: CGFloat  = finalCenter.x - containerCenter.x
        let deltaY: CGFloat  = finalCenter.y - containerCenter.y
        
        let scalation = CGAffineTransform(scaleX: scale, y: scale)
        //MARK: changing the deltas for positive to negative values will change the origin x and y of the transformed view
        let translation = CGAffineTransform(translationX: -deltaX, y: deltaY)
        
        let transform = scalation.concatenating(translation)
        

        print("scale \(scale)")
        containerView.animate(duration: self.animationduration, delay: self.delay, damping: self.damping, velocity: self.velocity, options: [self.options], transform: transform)
        //CALL IT HERE?
        self.applyScale(scale: scale, toView: containerView)
        //get the height of t
        let kHeight: CGFloat = 250
        
        let newRect = self.view.convert((scaledView?.frame)!, from: scaledView?.superview!)

        print("NEWRECT = \(newRect)")
//        let newFrame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: newRect.height)
//        overlay.frame = newFrame
//        self.view.addSubview(overlay)
        
    }
    
    fileprivate func applyScale(scale: CGFloat, toView view: UIView) {
        view.contentScaleFactor = scale
        view.layer.contentsScale = scale
        for subview in view.subviews {
            self.applyScale(scale: scale, toView: subview)
        }
    }
    
}


extension ViewController {
    
    func setUpKeyBoardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        
        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
        if let keyboardFrame = keyboardFrame {
            let keyboardHeightLocal = keyboardFrame.height
            let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            if let keyboardDuration = keyboardDuration {
                
                self.keyBoardHeight = keyboardHeightLocal
                //   let y = self.getTranslationY(from: keyboardHeight)
                // self.zoomIn(y)
            }
        }
    }
    
    //    func getTranslationY(from keyboardHeight: CGFloat) -> CGFloat {
    //
    ////        let textFieldInnerSpace = self.containerView.frame.height - self.textViewContainer.frame.maxY
    ////        let allContentFrameData = keyboardHeight + self.containerView.frame.height + self.containerView.frame.origin.y - textFieldInnerSpace
    ////        let y = self.view.frame.height - allContentFrameData
    ////        print("translationY \(y)")
    ////        return y
    //    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        
        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        if let keyboardDuration = keyboardDuration {
           // self.zoomOut(keyboardDuration)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}



