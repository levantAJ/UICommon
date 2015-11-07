//
//  NotificationMessageView.swift
//  UICommon
//
//  Created by Le Tai on 11/7/15.
//  Copyright © 2015 AJ. All rights reserved.
//

import UIKit
import SDWebImage

public class NotificationMessageView: UIView {
    @IBOutlet public weak var notificationImageView: UIImageView!
    @IBOutlet weak var notificationImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet public weak var notificationTitleLabel: UILabel!
    @IBOutlet public weak var notificationMessageLabel: UILabel!
    
    var willDismiss: (() -> Void)?
    var didDismiss: (() -> Void)?
    
    public var iconSize = Constants.NotificationMessageView.DefaultIconSize {
        didSet {
            UIView.animateWithDuration(Constants.NotificationMessageView.DefaultDuration, animations: { [weak self] () -> Void in
                guard let weakSelf = self else { return }
                self?.notificationImageViewWidthConstraint.constant = weakSelf.iconSize
                self?.notificationImageViewHeightConstraint.constant = weakSelf.iconSize
                self?.layoutIfNeeded()
            })
        }
    }
    
    public var iconImage: UIImage? {
        didSet {
            guard let iconImage = iconImage else { return }
            notificationImageView.image = iconImage
        }
    }
    
    public var iconURL: NSURL? {
        didSet {
            guard let iconURL = iconURL else {
                iconSize = 0
                return
            }
            notificationImageView.sd_setImageWithURL(iconURL) { [weak self] (image, _, _, _) -> Void in
                guard let image = image else {
                    self?.iconSize = 0
                    return
                }
                self?.iconSize = Constants.NotificationMessageView.DefaultIconSize
                self?.notificationImageView.image = image
            }
        }
    }
    
    public var title: String? {
        didSet {
            guard let title = title else { return }
            notificationTitleLabel.text = title
        }
    }
    
    public var message: String? {
        didSet {
            guard let message = message else { return }
            notificationMessageLabel.text = message
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Constants.NotificationMessageView.PrimaryBackgroundColor
    }
    
    public class func loadFromNib() -> NotificationMessageView? {
        let classBundle = NSBundle(forClass: NotificationMessageView.self)
        guard let notificationMessageView = classBundle.loadNibNamed(Constants.NotificationMessageView.Identifier, owner: nil, options: nil).first as? NotificationMessageView else {
            return nil
        }
        return notificationMessageView
    }
    
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let superview = superview else { return }
        frame = CGRect(x: 0, y: 0, width: superview.frame.width, height: frame.height)
        superview.bringSubviewToFront(self)
        hidden = true
    }
    
    public func showWithTitle(title: String, message: String, iconURLString: String? = nil) {
        guard let superview = superview else { return }
        hidden = false
        self.title = title
        self.message = message
        if let iconURLString = iconURLString {
            self.iconURL = NSURL(string: iconURLString)
        }
        superview.bringSubviewToFront(self)
    }
    
    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
}

extension Constants {
    struct NotificationMessageView {
        static let PrimaryBackgroundColor = UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1)
        
        static let SecondaryBackgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        static let DefaultIconSize = CGFloat(32)
        static let Identifier = "NotificationMessageView"
        static let DefaultDuration = 0.25
    }
}
