//
//  JeyMessage.swift
//  BlindMatrix
//
//  Created by Jeyaganthan's Mac Mini on 16/09/21.
//

import Foundation
import UIKit

public class JeyMessage: UIView {
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func draw(_ rect: CGRect) {
        // Drawing code
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8,height: 8))
        mainShape.frame = rect
        mainShape.path = path.cgPath
        mainShape.shadowColor = UIColor.black.cgColor
        mainShape.shadowOffset = CGSize(width: 1, height: 1)
        mainShape.shadowRadius = 15
        mainShape.shadowOpacity = 0.4
    }
    
    public enum Status : CaseIterable {
        case error
        case info
        case success
    }
    
    public enum Position {
        case top
        case bottom
    }
    
    public typealias JcompleteHandler = (JeyMessage) -> Void
    
    private var topConstraint : NSLayoutConstraint?
    private var bottomConstraint : NSLayoutConstraint?
    
    private var message = UILabel()
    private var title = UILabel()
    private var action : JcompleteHandler? = nil
    private var mainView = UIView()
    private var mainShape = CAShapeLayer()
    public  var duration : Double?
    private var position : Position = .top
    private var iconView : UIImageView!
    private var timer : Timer? = nil
    private(set) var status : Status = .error
    private(set) var config : JeyMessageConfig!
    
    public init(title : NSAttributedString,
                message : NSAttributedString,
                duration: Double? = 3.0,
                position: Position = .top,
                status : Status = .success,
                config:JeyMessageConfig = JeyMessageConfig.shared) {
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.config = config
        self.title.attributedText = title
        self.message.attributedText = message
        self.status = status
        self.duration = duration
        self.position = position
        setup()
    }
    
    public convenience init(title : String,
                            message : String,
                            duration: Double? = 3.0,
                            position: Position = .top,
                            status : Status = .success,
                            config:JeyMessageConfig = JeyMessageConfig.shared) {
        
        let attrTitle = NSAttributedString(string: title, attributes: [.font:config.titleFont,.foregroundColor:config.titleColor])
        
        let attrMessage = NSAttributedString(string: message, attributes: [.font:config.messageFont,.foregroundColor:config.messageColor])
        self.init(title: attrTitle, message: attrMessage, duration: duration, position: position, status: status, config: config)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        backgroundColor = UIColor.clear
        
        mainView.frame = bounds
        mainView.backgroundColor = UIColor.clear
        mainView.layer.addSublayer(mainShape)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: topAnchor),
            mainView.leftAnchor.constraint(equalTo: leftAnchor),
            mainView.rightAnchor.constraint(equalTo: rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainView.widthAnchor.constraint(equalToConstant: min(400, UIScreen.main.bounds.width - 32)),
            ])
        
        
        iconView = UIImageView()
        iconView.contentMode = .center
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        mainView.addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 30),
            iconView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            iconView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 8),
            iconView.topAnchor.constraint(equalTo: mainView.topAnchor),
            iconView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            ])
        
        title.numberOfLines = 0
        title.font = config.titleFont
        title.textColor = config.titleColor
        title.translatesAutoresizingMaskIntoConstraints = false
        title.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        title.setContentHuggingPriority(.required, for: .vertical)
        mainView.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 16),
            title.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 16),
            title.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -16),
            ])
        
        message.numberOfLines = 0
        message.font = config.messageFont
        message.textColor = config.messageColor
        message.translatesAutoresizingMaskIntoConstraints = false
        message.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        mainView.addSubview(message)
        NSLayoutConstraint.activate([
            message.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            message.leftAnchor.constraint(equalTo: title.leftAnchor, constant: 0),
            message.rightAnchor.constraint(equalTo: title.rightAnchor, constant: 0),
            message.bottomAnchor.constraint(equalTo: message.superview!.bottomAnchor, constant: -16),
            ])
        
        mainShape.fillColor = config.backgrounColors[status]?.cgColor
        iconView.image = config.images[status]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideMessages))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.onMoving(pan:)))
        addGestureRecognizer(pan)
        
        if let duration = duration {
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.hideMessages), userInfo: nil, repeats: false)
        }
    }
    
    @discardableResult public func show() -> JeyMessage {
        
        //remove all current messages
        for vim in UIApplication.keyWindow!.subviews {
            if let msg = vim as? JeyMessage {
                msg.hideMessages()
            }
        }
        
        UIApplication.keyWindow?.addSubview(self)
        topConstraint = topAnchor.constraint(equalTo: superview!.topAnchor, constant: UIApplication.shared.statusBarFrame.maxY + 16)
        centerXAnchor.constraint(equalTo: superview!.centerXAnchor, constant: 0).isActive = true
        
        if #available(iOS 11.0, *) {
            bottomConstraint = bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        } else {
            bottomConstraint = bottomAnchor.constraint(equalTo: superview!.bottomAnchor, constant: -16)
        }
        
        if position == .top {
            bottomConstraint?.isActive = false
            topConstraint?.isActive = true
        }
        else{
            topConstraint?.isActive = false
            bottomConstraint?.isActive = true
        }
        
        self.alpha = 0.1
        self.transform = CGAffineTransform(scaleX: 3, y: 3)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.transform = .identity
        }) { (B) in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut,.beginFromCurrentState], animations: {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }, completion: { (B) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = .identity
                })
            })
        }
        
        return self
    }
    
    
    @objc public func hideMessages(){
        
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve ,.curveEaseInOut,.beginFromCurrentState]
            , animations: {
                self.alpha = 0
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (B) in
            self.removeFromSuperview()
            self.action?(self)
        }
        
    }
    
    @objc func onMoving(pan: UIPanGestureRecognizer){
        //        let velo = pan.velocity(in: UIApplication.shared.keyWindow!)
        let point = pan.translation(in: UIApplication.keyWindow!)
        if pan.state == .began {
            timer?.invalidate()
            
        }else if pan.state == .changed {
            let alpha = min(1 - (abs(point.x)/150.0),1 - (abs(point.y)/150.0))
            
            self.alpha = alpha
            self.transform = CGAffineTransform(translationX: point.x, y: point.y)
            if alpha <= 0 {
                self.removeFromSuperview()
            }
            
        }else if pan.state == .ended {
            self.alpha = 1
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = .identity
            })
            
            if let duration = duration {
                timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.hideMessages), userInfo: nil, repeats: false)
            }
        }
    }
    
    @available(swift,deprecated: 1.1.0,message: "change to onDismiss")
    public func onHide(_ sender : @escaping JcompleteHandler){
        action = sender
    }
    
    public func onDismiss(_ sender : @escaping JcompleteHandler) {
        action = sender
    }
    
    /// show JeyMessage Nb:duration = nil to infinite, default is 3
    ///
    /// - Parameters:
    ///   - title: String of title
    ///   - message: String of message
    ///   - duration: Optional duration, default value is 3.0
    ///   - position: Optional Position, default value is .top
    ///   - status: Optional status, default value is .success
    ///   - config: Optional config, default is using JeyMessageConfig.shared
    /// - Returns: JeyMessage for chaining function like onhide
    @discardableResult public static func show(title : String,message : String,duration: Double? = 3.0 , position: Position = .top,status : Status = .success ,config:JeyMessageConfig = JeyMessageConfig.shared) -> JeyMessage {
        let attrTitle = NSAttributedString(string: title, attributes: [.font:config.titleFont,.foregroundColor:config.titleColor])
        
        let attrMessage = NSAttributedString(string: message, attributes: [.font:config.messageFont,.foregroundColor:config.messageColor])
        
        let msg = JeyMessage(title: attrTitle, message: attrMessage, duration: duration, position: position, status: status, config:config)
        msg.show()
        return msg
    }
    
    /// show JeyMessage Nb:duration = nil to infinite, default is 3
    ///
    /// - Parameters:
    ///   - title: NSAttributedString of title
    ///   - message: NSAttributedString of message
    ///   - duration: Optional duration, default value is 3.0
    ///   - position: Optional Position, default value is .top
    ///   - status: Optional status, default value is .success
    /// - Returns: JeyMessage for chaining function like onhide
    @discardableResult public static func show(title : NSAttributedString,message : NSAttributedString,duration: Double? = 3.0 , position: Position = .top,status : Status = .success) -> JeyMessage {
        let msg = JeyMessage(title: title, message: message, duration: duration, position: position, status: status, config:JeyMessageConfig.shared)
        msg.show()
        return msg
    }
    
    /** hide all JeyMessage class */
    public static func hide(){
        for vim in UIApplication.keyWindow!.subviews {
            if let msg = vim as? JeyMessage {
                msg.hideMessages()
            }
        }
    }
    
}

public struct JeyMessageConfig {
    
    public static var shared = JeyMessageConfig()
    
    public var titleFont : UIFont = UIFont.boldSystemFont(ofSize: 15)
    public var titleColor : UIColor = .white
    public var messageColor : UIColor = .white
    public var messageFont : UIFont = UIFont.systemFont(ofSize: 14)
    
    var images : [JeyMessage.Status : UIImage] = [:]
    var backgrounColors : [JeyMessage.Status : UIColor] = [:]
    
    
    init() {

        for status in JeyMessage.Status.allCases {
            switch status {
            case .info:
                images[status] = UIImage(named: "info")
                backgrounColors[status] = UIColor(red: CGFloat(241.0/255.0), green: CGFloat(196.0/255.0), blue: CGFloat(15.0/255.0), alpha: 1)
            case .error:
                images[status] = UIImage(named: "error")
                backgrounColors[status] = UIColor(red: CGFloat(231.0/255.0), green: CGFloat(76.0/255.0), blue: CGFloat(60.0/255.0), alpha: 1)
            case .success:
                images[status] = UIImage(named: "success")
                backgrounColors[status] = UIColor(red: CGFloat(46.0/255.0), green: CGFloat(204.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1)
            }
        }
    }
    
    
    public mutating func setImage(_ image:UIImage?, status: JeyMessage.Status) {
        guard let img = image else { return }
        images[status] = img
    }
    
    public mutating func setBackgroundColor(_ color:UIColor?, status: JeyMessage.Status) {
        guard let clr = color else { return }
        backgrounColors[status] = clr
    }
}




class NotificationMessage : NSObject {
    
    static let shared = NotificationMessage()
    
    func showError(_ notificationString : String){
        var config = JeyMessageConfig.shared
        config.setBackgroundColor(.red, status: .error)
        JeyMessage.show(title: "Info", message: notificationString,duration: 5.0, status: .error, config: config)
    }
    
    func showSucess(_ notificationString : String){
        var config = JeyMessageConfig.shared
        config.setBackgroundColor(.red, status: .success)
        JeyMessage.show(title: "Info", message: notificationString,duration: 5.0, status: .success, config: config)
    }
}
