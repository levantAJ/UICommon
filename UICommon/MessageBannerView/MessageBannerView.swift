//
//  MessageBannerView.swift
//  UICommon
//
//  Created by Le Tai on 10/15/15.
//  Copyright © 2015 AJ. All rights reserved.
//

import UIKit

public enum MessageBannerViewType {
    case Error
    case Loading
    case Success
    case None
    
    func backgroundColor() -> UIColor {
        switch self {
        case .Error:
            return Constants.Color.BlackColor
        case .Loading:
            return Constants.Color.YellowColor
        case .Success:
            return Constants.Color.BlueColor
        case .None:
            return Constants.Color.BlackColor
        }
    }
}

public class MessageBannerView: UIView {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var wrapperViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabelHeightConstraint: NSLayoutConstraint!
    
    public var messageBannerViewType = MessageBannerViewType.None {
        didSet {
            wrapperView.backgroundColor = messageBannerViewType.backgroundColor()
        }
    }
    
    public var timeToDismis = Constants.MessageBannerView.DismissedSeconds
    
    public var touchToClose = true
    public var autoHidden = true
    var isShowing = false
    var timer: NSTimer?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        hidden = true
        messageLabelHeightConstraint.constant = Constants.MessageBannerView.Height
        wrapperViewTopConstraint.constant = -messageLabelHeightConstraint.constant
    }
    
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
    
    public func showWithMessage(message: String?, messageBannerViewType: MessageBannerViewType = .None, completion: CompletionClosure? = nil) {
        if let message = message {
            dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                guard let weakSelf = self, superview = weakSelf.superview else { return }
                superview.bringSubviewToFront(weakSelf)
                weakSelf.messageBannerViewType = messageBannerViewType
                weakSelf.messageLabel.text = message
                weakSelf.messageLabelHeightConstraint.constant = message.sizeWithFont(weakSelf.messageLabel.font, forWidth: weakSelf.messageLabel.frame.width).height + Constants.MessageBannerView.Padding
                if weakSelf.hidden {
                    weakSelf.hidden = false
                    weakSelf.isShowing = true
                    UIView.animateWithDuration(Constants.MessageBannerView.Duration,
                        animations: { () -> Void in
                            weakSelf.wrapperViewTopConstraint.constant = 0
                            weakSelf.layoutIfNeeded()
                        }) { (finished) -> Void in
                            weakSelf.hidden = false
                            weakSelf.isShowing = false
                            completion?()
                    }
                }
                if messageBannerViewType != .Loading && weakSelf.autoHidden {
                    weakSelf.timer = NSTimer.scheduledTimerWithTimeInterval(weakSelf.timeToDismis, target: weakSelf, selector: "forcedHide", userInfo: nil, repeats: false)
                }
                })
        } else {
            hide()
        }
    }
    
    public func forcedHide() {
        hide()
    }
    
    public func hide(completion: CompletionClosure? = nil) {
        if !hidden {
            if isShowing {
                isShowing = false
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Constants.MessageBannerView.Delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    self.hide()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), { [weak self] () -> Void in
                    self?.timer?.invalidate()
                    self?.timer = nil
                    if let weakSelf = self {
                        UIView.animateWithDuration(Constants.MessageBannerView.Duration,
                            animations: { () -> Void in
                                weakSelf.wrapperViewTopConstraint.constant = -weakSelf.messageLabelHeightConstraint.constant
                                weakSelf.layoutIfNeeded()
                            }) { (finished) -> Void in
                                weakSelf.hidden = true
                                completion?()
                        }
                    }
                    })
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
        static let Delay = Double(1)
        static let DismissedSeconds = 2.0
    }
}
