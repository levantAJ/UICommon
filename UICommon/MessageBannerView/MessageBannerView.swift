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
    var timer: Timer?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        isHidden = true
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
        if !isHidden {
            frame = CGRect(x: frame.minX,
                           y: frame.minY,
                           width: frame.width,
                           height: messageLabelHeightConstraint.constant)
        }
    }
    
    public func showWithMessage(message: String?, messageBannerViewType: MessageBannerViewType = .None, completion: CompletionClosure? = nil) {
        if let message = message {
            DispatchQueue.main.async {
                guard let superview = self.superview else { return }
                superview.bringSubviewToFront(self)
                self.messageBannerViewType = messageBannerViewType
                self.messageLabel.text = message
                self.messageLabelHeightConstraint.constant = message.sizeWithFont(font: self.messageLabel.font, forWidth: self.messageLabel.frame.width).height + Constants.MessageBannerView.Padding
                if self.isHidden {
                    self.isHidden = false
                    self.isShowing = true
                    UIView.animate(withDuration: Constants.MessageBannerView.Duration,
                                   animations: { () -> Void in
                                    self.wrapperViewTopConstraint.constant = 0
                                    self.layoutIfNeeded()
                    }) { (finished) -> Void in
                        self.isHidden = false
                        self.isShowing = false
                        completion?()
                    }
                }
                if messageBannerViewType != .Loading && self.autoHidden {
                    self.timer = Timer.scheduledTimer(timeInterval: self.timeToDismis, target: self, selector: #selector(self.forcedHide), userInfo: nil, repeats: false)
                }
            }
        } else {
            hide()
        }
    }
    
    @objc public func forcedHide() {
        hide()
    }
    
    public func hide(completion: CompletionClosure? = nil) {
        if !isHidden {
            if isShowing {
                isShowing = false
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.MessageBannerView.Delay) {
                    self.hide()
                }
            } else {
                DispatchQueue.main.async {
                    self.timer?.invalidate()
                    self.timer = nil
                    UIView.animate(withDuration: Constants.MessageBannerView.Duration,
                                   animations: { () -> Void in
                                    self.wrapperViewTopConstraint.constant = -self.messageLabelHeightConstraint.constant
                                    self.layoutIfNeeded()
                    }) { (finished) -> Void in
                        self.isHidden = true
                        completion?()
                    }
                }
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
        let classBundle = Bundle(for: MessageBannerView.self)
        if let messageBannerView = classBundle.loadNibNamed(Constants.MessageBannerView.Identifier, owner: nil, options: nil)?.first as? MessageBannerView {
            return messageBannerView
        }
        return nil
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
