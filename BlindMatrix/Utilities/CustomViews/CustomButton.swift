//
//  CustomButton.swift
//  Blink_Mobility
//
//  Created by Jeyaganthan's Mac Mini on 04/09/21.
//

import UIKit
enum customAlignment: String {
    case left = "left" // lowercase to make it case-insensitive
    case right = "right"
    case center = "center"
    case justify = "justify"
    case none = "none"
}
@objc enum Shape: Int {
    case None
    case Rectangle
    case Triangle
    case Circle
    
    init(named shapeName: String) {
        switch shapeName.lowercased() {
        case "rectangle": self = .Rectangle
        case "triangle": self = .Triangle
        case "circle": self = .Circle
        default: self = .None
        }
    }
}



class CustomButton: UIButton {
    var originalButtonText: String?
    var originalButtonImage: UIImage?

    var activityIndicator: UIActivityIndicatorView!
    
    required init(coder aDecoder:NSCoder){
        super.init(coder: aDecoder)!
        
//        self.titleLabel?.font=FontHandler.sharedinstance.setFontAndSize(font: (self.titleLabel?.font)!)
        
        
    }
    
     var alignmentname = customAlignment.none // default shape
     @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var isAddTextColor: Bool = false {
        didSet {
            if(isAddTextColor)
            {
                self.setTitleColor(.blue, for: .normal)
            }
        }
    }

  
    
    
    @IBInspectable var isAddShadow: Bool = false {
        didSet {
            if(isRoundedCorner)
            {
                let shadowLayer = UIView(frame: self.frame)
                shadowLayer.backgroundColor = UIColor.clear
                shadowLayer.layer.shadowColor = UIColor.darkGray.cgColor
                shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
                shadowLayer.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
                shadowLayer.layer.shadowOpacity = 0.5
                shadowLayer.layer.shadowRadius = 1
                shadowLayer.layer.masksToBounds = true
                shadowLayer.clipsToBounds = false
                self.superview?.addSubview(shadowLayer)
                self.superview?.bringSubviewToFront(self)
            }
        }
    }


    
    @IBInspectable var Alignment: String? {
        willSet {
            // Ensure user enters a valid shape while making it lowercase.
            // Ignore input if not valid.
            if let newShape = customAlignment(rawValue: newValue?.lowercased() ?? "") {
                alignmentname = newShape
                if(alignmentname == customAlignment.right)
                {
                    self.titleLabel?.textAlignment = .right
                 }
               else if(alignmentname == customAlignment.left)
                {
                    self.titleLabel?.textAlignment = .left
                }
               else if(alignmentname == customAlignment.justify)
                {
                    self.titleLabel?.textAlignment = .justified
                }
               else if(alignmentname == customAlignment.none)
                {
                    self.titleLabel?.textAlignment = .natural
                }
               else if(alignmentname == customAlignment.center)
                {
                    self.titleLabel?.textAlignment = .center
                }



            }
        }
    }
    
    @IBInspectable var isAddbackgroudColor: Bool = false {
        didSet {
            if(isAddbackgroudColor)
            {
                //signInBtn.loadButtonGradient()
                self.backgroundColor = .white
             }
        }
    }

 
    @IBInspectable var isRoundedCorner: Bool = false {
        didSet {
            if(isRoundedCorner)
            {
                layer.cornerRadius = self.frame.size.height/2;
                self.clipsToBounds = true;
            }
         }
    }
    
    @IBInspectable var FitImage: Bool = false {
        didSet {
            if(FitImage)
            {
                imageView?.contentMode = .scaleAspectFit
            }
         }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }


    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    func underlineButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        
        
        guard titleString.length>0 else {
            return
        }
        
        titleString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
    
    func showLoading() {
        originalButtonText = self.titleLabel?.text
        originalButtonImage = self.imageView?.image
        self.setTitle("", for: UIControl.State.normal)
        self.setImage(UIImage(named: ""), for: UIControl.State.normal)
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        self.isUserInteractionEnabled = false
        showSpinning()
    }
    
    func hideLoading() {
        if(originalButtonImage?.hasContent==true){
            self.setImage(originalButtonImage, for: UIControl.State.normal)
        }
        self.setTitle(originalButtonText, for: UIControl.State.normal)
        if(activityIndicator != nil){
            activityIndicator.stopAnimating()
        }
         self.isUserInteractionEnabled = true
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
