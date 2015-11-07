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
    
    public var iconSize = Constants.NotificationMessageView.DefaultIconSize {
        didSet {
            notificationImageViewWidthConstraint.constant = iconSize
            notificationImageViewHeightConstraint.constant = iconSize
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
                guard let image = image else { return }
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
}

extension Constants {
    struct NotificationMessageView {
        static let PrimaryBackgroundColor = UIColor(red: 0.855, green: 0.855, blue: 0.855, alpha: 1)
        
        static let SecondaryBackgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        static let DefaultIconSize = CGFloat(32)
        static let Identifier = "NotificationMessageView"
    }
}
