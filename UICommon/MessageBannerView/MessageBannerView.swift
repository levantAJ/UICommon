//
//  MessageBannerView.swift
//  UICommon
//
//  Created by Le Tai on 10/15/15.
//  Copyright © 2015 AJ. All rights reserved.
//

import UIKit
import Utils

public class MessageBannerView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var wrapperViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabelHeightConstraint: NSLayoutConstraint!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        hidden = true
        messageLabelHeightConstraint.constant = Constants.MessageBannerView.Height
        wrapperViewTopConstraint.constant = -messageLabelHeightConstraint.constant
    }
    
    public var touchToClose: Bool = true
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            frame = CGRect(x: 0,
                y: 0,
                width: superview.frame.width,
                height: messageLabelHeightConstraint.constant)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !hidden {
            frame = CGRect(x: frame.minX,
                y: frame.minY,
                width: frame.width,
                height: messageLabelHeightConstraint.constant)
        }
    }
    
    public func showWithMessage(message: String?) {
        if let message = message {
            messageLabel.text = message
            messageLabelHeightConstraint.constant = message.sizeWithFont(messageLabel.font, forWidth: messageLabel.frame.width).height + Constants.MessageBannerView.Padding
            if hidden {
                hidden = false
                UIView.animateWithDuration(Constants.MessageBannerView.Duration,
                    animations: { () -> Void in
                        self.wrapperViewTopConstraint.constant = 0
                        self.layoutIfNeeded()
                    }) { (finished) -> Void in
                        self.hidden = false
                }
            }
        } else {
            hide()
        }
    }
    
    public func hide() {
        if !hidden {
            UIView.animateWithDuration(Constants.MessageBannerView.Duration,
                animations: { () -> Void in
                    self.wrapperViewTopConstraint.constant = -self.messageLabelHeightConstraint.constant
                    self.layoutIfNeeded()
                }) { (finished) -> Void in
                    self.hidden = true
            }
        }
    }
    
    public func alwaysKeepOnTopOfScrollView(scrollView: UIScrollView) {
        frame = CGRect(x: 0,
            y: scrollView.contentOffset.y,
            width: frame.width,
            height: messageLabelHeightConstraint.constant)
    }
    
    public class func loadFromNib() -> MessageBannerView? {
        let classBundle = NSBundle(forClass: MessageBannerView.self)
        if let messageBannerView = classBundle.loadNibNamed(Constants.MessageBannerView.Identifier, owner: nil, options: nil).first as? MessageBannerView {
            return messageBannerView
        }
        return nil
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchToClose {
            hide()
        }
    }
}

extension Constants {
    struct MessageBannerView {
        static let Identifier = "MessageBannerView"
        static let Height = CGFloat(32.5)
        static let Duration = 0.35
        static let Padding = CGFloat(16)
    }
}