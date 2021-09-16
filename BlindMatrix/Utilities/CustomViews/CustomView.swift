//
//  CustomView.swift
//  Blink_Mobility
//
//  Created by Jeyaganthan's Mac Mini on 04/09/21.
//

import UIKit
//import UIGradient

enum ShadowLocation: String {
    case bottom
    case top
}
class CustomView: UIView {
     /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
     @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            //layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var isAddbackgroudColor: Bool = false {
        didSet {
            if(isAddbackgroudColor)
            {
                self.backgroundColor = .systemBackground
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
}
 
extension UIView{
    func animateConstraint(){
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }, completion: {finished in })
    }
    func animateConstraintForShrinkAndExpand(){
        
        UIView.animate(withDuration: 0.6, animations: {
            self.layoutIfNeeded()
        }, completion: {finished in })
    }
    
    func animateConstraintWithBlock(completionHandler: @escaping () -> ()?)
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }, completion: {finished in
            completionHandler()
        })
    }
    
    func showViewWithAnimation(completionHandler: @escaping () -> ()){
         self.alpha=0
        self.isHidden = false
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.alpha=1
        }, completion: {finished in
            completionHandler()
        })
    }
    func hideViewWithAnimation(completionHandler: @escaping () -> ()){
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.alpha=0
        }, completion: {finished in
            self.isHidden = true
             completionHandler()
        })
    }
    func scale(by scale: CGFloat) {
        self.contentScaleFactor = scale
        for subview in self.subviews {
            subview.scale(by: scale)
        }
    }
    
    func getImage(scale: CGFloat? = nil) -> UIImage {
        let newScale = scale ?? UIScreen.main.scale
        self.scale(by: newScale)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = newScale
        
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)
        
        let image = renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }
        
        return image
    }
    func roundCorners( radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, cornerRadius: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: CGRect.init(x: self.bounds.origin.x, y: self.bounds.origin.y, width: UIScreen.main.bounds.size.width-20, height: self.bounds.size.height)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    
    func animateAsPulse(){
        let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1.0
        pulseAnimation.fromValue = 0.0
        pulseAnimation.toValue = NSNumber(value: 1.0)
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(pulseAnimation, forKey: nil)
    }
    func addShadowToBottomOrTop(location: ShadowLocation, color: UIColor = .gray, opacity: Float = 0.1, radius: CGFloat = 2.0) {
        switch location {
        case .bottom:
            addShadow(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -2), color: color, opacity: opacity, radius: radius)
        }
    }
    
    func addShadow(offset: CGSize, color: UIColor = .gray, opacity: Float = 0.1, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
//    func loadAddressMarkerGradient(isPickUp:Bool){
//        var backColor:UIColor = UIColor()
//        if(isPickUp==true){
//            backColor = UIColor.fromGradientWithDirection(.topLeftToBottomRight, frame: self.frame, colors: [PickUpMarkerStartColor!, PickUpMarkerEndColor!]) ?? AppThemeColor!
//        }else{
//            backColor = UIColor.fromGradientWithDirection(.topLeftToBottomRight, frame: self.frame, colors: [DropMarkerStartColor!, DropMarkerEndColor!]) ?? AppThemeColor!
//        }
//        self.backgroundColor = backColor
//    }
//    func loadThemeGradient(){
//        self.backgroundColor = UIColor.fromGradientWithDirection(.topLeftToBottomRight, frame: self.frame, colors: [AppThemeColor!, AppThemeColor!])
//    }
//    func loadThemeButtonGradient(){
//        self.backgroundColor = UIColor.fromGradientWithDirection(.topLeftToBottomRight, frame: self.frame, colors: [AppThemeColor!, AppThemeColor!])
//    }
//    func loadGrayButtonGradient(){
//        self.backgroundColor = UIColor.fromGradientWithDirection(.topLeftToBottomRight, frame: self.frame, colors: [UIColor.lightGray, UIColor.lightGray])
//    }
//    func loadThemeTintGradient(){
//        self.tintColor = UIColor.fromGradientWithDirection(.topLeftToBottomRight, frame: self.frame, colors: [AppThemeColor!, AppThemeColor!])
//    }
//    func loadThemeBorderGradient(){
//        self.layer.borderColor = UIColor.fromGradientWithDirection(.topLeftToBottomRight, frame: self.frame, colors: [AppThemeColor!, AppThemeColor!])?.cgColor
//    }
//    func GradientLeftColorAndRightTransparent(){
//        self.backgroundColor = UIColor.fromGradientWithDirection(.leftToRight, frame: self.frame, colors: [UIColor.white, UIColor.clear])
//
//    }
    func setbottomLine(viewArray:NSArray){
        for view:UIView in viewArray as! [UIView]{
            let bottomLine:UIView = UIView()
            bottomLine.frame = CGRect(x: 0, y: view.frame.height-1, width: view.frame.size.width, height: 0.5)
            bottomLine.backgroundColor = .systemBackground
            view.addSubview(bottomLine)
        }
    }
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {self.alpha = 1.0}, completion: nil)
    }
  
}

extension UICollectionView {
    
    var centerPoint : CGPoint {
        
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }
    
    var centerCellIndexPath: IndexPath? {
        
        if let centerIndexPath: IndexPath  = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
}


